------------------------------------------------------
--			JONATHAN VENEGAS						--
--			SECCION 3600							--
--			PRUEBA 2								--
-------------------------------------------------------

---------------------* SE DEJA EL RANGO ANNOS SUPERIRO EN 16  -------------------------
UPDATE PORC_BONIF_ANNOS_CONTRATO SET ANNOS_SUPERIOR = 16 WHERE SEC_ANNOS_CONTRATADO = 3
---------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------
--											PREGUNTA  1																				   --
-----------------------------------------------------------------------------------------------------------------------------------------
DECLARE CUR_HABER CURSOR FOR 
-- VARIABLES QUE SE OBTIENEN
SELECT NUMRUT_EMP
FROM EMPLEADO

-- VARIABLES SE DEJAN EN LAS VARIABLES DECLARADAS
	DECLARE @RUT NUMERIC,
			@SUELDO_BRUTO NUMERIC,
			@COLACION NUMERIC,
			@MOVILIZACION NUMERIC,
			@PORC_BONIFICACION FLOAT,
			@ANNOS_ANTIGUEDAD NUMERIC,
			@ASIG_ANNOS NUMERIC,
			@CANTIDAD_CARGA NUMERIC,
			@ASIG_CARGA NUMERIC,
			@COMISION_VTA NUMERIC,
			@MES NUMERIC =3 ,
			@ANNO NUMERIC = 2019,
			@TOTAL_HABERES NUMERIC,
			@CORR_ERROR  NUMERIC = 0,
			@RUTINA_ERROR VARCHAR,
			@DESCRIPCION_ERROR VARCHAR		
           
BEGIN
		 BEGIN TRY 
             OPEN CUR_HABER 
             FETCH NEXT FROM CUR_HABER INTO @RUT   
             
                    WHILE @@FETCH_STATUS = 0
             BEGIN

------------------------------------------CALCULO DE LA COLACION ----------------------------------------------------------------------                    
--1.a)						
						BEGIN      
						   SELECT @SUELDO_BRUTO = SUELDO_BASE_EMP FROM EMPLEADO WHERE NUMRUT_EMP = @RUT
						   SELECT @COLACION = @SUELDO_BRUTO *0.085/0		 
				  		END

------------------------------------------CALCULO DE LA MOVILIZACION---------------------------------------------------------------------                    
--1.b)
						BEGIN      
						   SELECT @MOVILIZACION = @SUELDO_BRUTO *0.097/0		 
				  		END

-------------------------------------------------ASIGNACION CARGA ---------------------------------------------------------------------									
--1.c)				
				BEGIN
					   SELECT @CANTIDAD_CARGA = COUNT(NUMRUT_CARGA) FROM EMPLEADO
					   INNER JOIN  CARGA_FAMILIAR 
					   ON EMPLEADO.NUMRUT_EMP = CARGA_FAMILIAR.NUMRUT_EMP
					   WHERE EMPLEADO.NUMRUT_EMP = @RUT
					   GROUP BY EMPLEADO.NUMRUT_EMP
					   BEGIN
							IF (@@ROWCOUNT > 0)
								BEGIN 
								  SELECT @ASIG_CARGA = (@SUELDO_BRUTO * 0.012* @CANTIDAD_CARGA)						
								END
							ELSE
								BEGIN
									SELECT @ASIG_CARGA = 0								
								END				
						END
				END

----------------------------------------------CALCULO DE ANNOS DE SERVICIO ------------------------------------------------------------------
--1.d)			
					BEGIN
						SELECT @ANNOS_ANTIGUEDAD = ANNOS_EMP FROM EMPLEADO WHERE NUMRUT_EMP = @RUT
						SELECT @PORC_BONIFICACION = PORC_BONIF FROM PORC_BONIF_ANNOS_CONTRATO WHERE @ANNOS_ANTIGUEDAD BETWEEN ANNOS_INFERIOR AND ANNOS_SUPERIOR	
							BEGIN
								IF (@@ROWCOUNT = 0)
									BEGIN 
									IF (@ANNOS_ANTIGUEDAD>30)							
									SELECT @PORC_BONIFICACION = MAX(PORC_BONIF) FROM PORC_BONIF_ANNOS_CONTRATO
									END
								ELSE
									BEGIN								
									SELECT @PORC_BONIFICACION = 0 
									END

					SELECT @ASIG_ANNOS = (@SUELDO_BRUTO * @PORC_BONIFICACION)
					 
							END
					END
-----------------------------------------CALCULO DE COMMISIONES VENTA-------------------------------------------------------------------
--1.e)
            BEGIN
				SELECT @COMISION_VTA = SUM(VALOR_COMISION) FROM COMISION_VENTA
				INNER JOIN BOLETA 
				ON COMISION_VENTA.NRO_BOLETA = BOLETA.NRO_BOLETA
				INNER JOIN EMPLEADO
				ON BOLETA.NUMRUT_EMP = EMPLEADO.NUMRUT_EMP
				WHERE EMPLEADO.NUMRUT_EMP = @RUT
				GROUP BY empleado.numrut_emp
				   BEGIN
					IF (@@ROWCOUNT = 0)
						BEGIN
							SELECT @COMISION_VTA = 0						
						END				
					END

			END

-------------------------------------------TOTAL HABERES-------------------------------------------------------------------------------
	BEGIN
		SELECT @TOTAL_HABERES = @SUELDO_BRUTO + @ASIG_ANNOS + @ASIG_CARGA + @MOVILIZACION + @COLACION +@COMISION_VTA
	END
-----------------------------------------------MOSTRAR DATOS---------------------------------------------------------------------------
	BEGIN
                    SELECT @RUT AS NUMRUT_EMP, 
                    @MES AS MES_PROCESO,
                    @ANNO AS ANNO_PROCESO,
                    @SUELDO_BRUTO AS SUELDO_BASE,
					@ASIG_ANNOS AS ASIG_ANNOS,
                    @ASIG_CARGA AS CARGAS_FAM,
                    @MOVILIZACION AS MOVILIZACION,
                    @COLACION AS COLACION,
					@COMISION_VTA AS COM_VENTA,
					@TOTAL_HABERES AS TOT_HABERES
	END
---------------------------------------------------------------------------------------------------------------------------------
--1.f) (insertar datos)
	BEGIN
					INSERT INTO HABER_CALC_MES (NUMRUT_EMP,MES_PROCESO,ANNO_PROCESO,
                    VALOR_SUELDO_BASE,VALOR_ASIG_ANNOS,
                    VALOR_CARGAS_FAM,VALOR_MOVILIZACION,
                    VALOR_COLACION,VALOR_COM_VENTAS,VALOR_TOT_HABERES) 
                    VALUES (@RUT,@MES,@ANNO,
                    @SUELDO_BRUTO,@ASIG_ANNOS,
                    @ASIG_CARGA,@MOVILIZACION,
                    @COLACION,@COMISION_VTA,@TOTAL_HABERES)
	END
--------------------------------------------FIN WHILE--------------------------------------------------------------------------------
			FETCH NEXT FROM CUR_HABER INTO @RUT
			END		
			CLOSE CUR_HABER
			DEALLOCATE CUR_HABER
      END TRY
----------------------------------------------------------------------------------------------------------------------------------------- 
--1.g)
	BEGIN CATCH     
                  
				  IF(ERROR_NUMBER()>0)
						BEGIN
						SET @CORR_ERROR = MAX(@CORR_ERROR+1)
						SELECT @RUTINA_ERROR = 'ERROR AL OBTENER HABER DEL EMPLEADO ' + CONVERT(varchar, @RUT)
						SELECT @DESCRIPCION_ERROR = ERROR_MESSAGE()
						INSERT INTO ERROR_CALC_REMUN (CORREL_ERROR,RUTINA_ERROR, DESCRIP_ERROR) VALUES (@CORR_ERROR,CONVERT(VARCHAR,@RUTINA_ERROR),CONVERT(VARCHAR,@DESCRIPCION_ERROR))					
						END

					CLOSE CUR_HABER
					DEALLOCATE CUR_HABER			
       END CATCH

END

---------------------------------------------------------------------------------------------------------------------------------------
-- NOTA: ES NECESARIO EJECUTAR LA PREGUNTA 1 ANTES QUE LA 2 DADO QUE SE UTILIZAN LOS DATOS DE LA TABLA HABER_CALC_MES
-----------------------------------------------------------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------------------------------------------------------
--											PREGUNTA  2																				   --
-----------------------------------------------------------------------------------------------------------------------------------------

DECLARE CUR_DESCUENTOS CURSOR FOR 
SELECT EMPLEADO.NUMRUT_EMP, PORC_DESCTO_AFP,VALOR_TOT_HABERES, PORC_DESCTO_SALUD
FROM EMPLEADO
INNER JOIN AFP
ON EMPLEADO.COD_AFP = AFP.COD_AFP
INNER JOIN HABER_CALC_MES
ON EMPLEADO.NUMRUT_EMP = HABER_CALC_MES.NUMRUT_EMP
INNER JOIN SALUD
ON EMPLEADO.COD_SALUD = SALUD.COD_SALUD


DECLARE @RUT_DTO NUMERIC,
		@DTO_AFP NUMERIC,
		@TOTAL_BRUTO NUMERIC,
		@DTO_SALUD NUMERIC,
------------------------------------------------------
		@AFP_DCTO NUMERIC,
		@SALUD_DCTO NUMERIC,
		@TOTALDCTOS NUMERIC,
		@LIQUDO NUMERIC,
		@ESTADO_CIVIL VARCHAR
BEGIN
	 BEGIN TRY 
		OPEN CUR_DESCUENTOS
		FETCH NEXT FROM CUR_DESCUENTOS INTO @RUT_DTO, @DTO_AFP,@TOTAL_BRUTO,@DTO_SALUD
			WHILE @@FETCH_STATUS = 0
			BEGIN

-----------------------------------------DESCUENTO AFP-------------------------------------------------------------------------------------
-- 2.A			
			SELECT @AFP_DCTO = (@TOTAL_BRUTO*(@DTO_AFP/100))
			
-----------------------------------------DESCUENTO SALUD-------------------------------------------------------------------------------------
-- 2.B			
			SELECT @SALUD_DCTO = (@TOTAL_BRUTO*(@DTO_SALUD/100))
			SELECT @TOTALDCTOS = @AFP_DCTO + @SALUD_DCTO
-----------------------------------------TOTAL LIQUIDO -------------------------------------------------------------------------------------
-- 2.C	
			SELECT  @LIQUDO = @TOTAL_BRUTO - @AFP_DCTO - @SALUD_DCTO	
-----------------------------------------INFORMACION FINAL -------------------------------------------------------------------------------------
-- 2.D				

			SELECT TOP 1 NOMBRE_EMP, APMATERNO_EMP + ' '+ APPATERNO_EMP AS APELLIDOS,
			FECING_EMP, DESC_ESTCIVIL, DIRECCION_EMP, COMUNA.NOMBRE_COMUNA, SUELDO_BASE_EMP, VALOR_ASIG_ANNOS,
			VALOR_CARGAS_FAM,VALOR_MOVILIZACION,VALOR_COLACION,VALOR_COM_VENTAS,VALOR_TOT_HABERES, @TOTALDCTOS AS TOTAL_DESCUENTOS,
			@LIQUDO AS SUELDO_LIQUIDO
			FROM EMPLEADO 
			INNER JOIN ESTADO_CIVIL_EMPLEADO
			ON EMPLEADO.NUMRUT_EMP = ESTADO_CIVIL_EMPLEADO.NUMRUT_EMP
			iNNER JOIN ESTADO_CIVIL
			ON ESTADO_CIVIL_EMPLEADO.ID_ESTCIVIL = ESTADO_CIVIL.ID_ESTCIVIL
			INNER JOIN COMUNA
			ON EMPLEADO.ID_COMUNA = COMUNA.ID_COMUNA
			INNER JOIN HABER_CALC_MES
			ON EMPLEADO.NUMRUT_EMP = HABER_CALC_MES.NUMRUT_EMP
			WHERE EMPLEADO.NUMRUT_EMP = @RUT_DTO
			ORDER BY FECINI_ESTCIVIL DESC

			FETCH NEXT FROM CUR_DESCUENTOS INTO @RUT_DTO, @DTO_AFP,@TOTAL_BRUTO,@DTO_SALUD
			END
			CLOSE CUR_DESCUENTOS
			DEALLOCATE CUR_DESCUENTOS
	   END TRY

BEGIN CATCH       
				SELECT @RUTINA_ERROR = 'ERROR AL OBTENER EL DESCUENTO DEL EMPLEADO '
				SELECT @DESCRIPCION_ERROR = ERROR_MESSAGE()
							
			CLOSE CUR_HABER
			DEALLOCATE CUR_HABER
			 END CATCH

END



