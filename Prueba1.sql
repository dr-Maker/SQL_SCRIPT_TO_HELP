
--use PRUEBA_N1_TBD

--Pregunta 1 

select empleado.numrut_emp,dvrut_emp, nombre_emp, appaterno_emp,apmaterno_emp, sueldo_base_emp, fonofijo_emp,celular_emp, fecini_estcivil
from empleado
inner join ESTADO_CIVIL_EMPLEADO
on empleado.numrut_emp = ESTADO_CIVIL_EMPLEADO.numrut_emp
inner join  estado_civil
on ESTADO_CIVIL_EMPLEADO.id_estcivil = estado_civil.id_estcivil
where estado_civil.id_estcivil =2


--Pregunta 2


select numrut_emp, dvrut_emp, nombre_emp,appaterno_emp, apmaterno_emp, direccion_emp, nombre_comuna
from empleado
inner join comuna
on empleado.id_comuna = comuna.id_comuna
Where comuna.id_comuna IN(86,128,92,89)  




--Pregunta 3


declare @añoActual numeric = 2019

select  nombre_emp + ' ' + appaterno_emp + ' '+ appaterno_emp as nombre_completo,
sueldo_base_emp,
convert(varchar(10),fecing_emp,103) as fecha_ingreso,
@añoActual-year(fecing_emp) as antiguedad_años,
convert(int,round(((sueldo_base_emp/9)*(@añoActual-year(fecing_emp))),0,0)) as bono_emp
from empleado 
 where fecing_emp  < '01/01/1990'  



 --Pregunta 4


select nro_boleta, empleado.numrut_emp, dvrut_emp,nombre_emp, appaterno_emp,apmaterno_emp, monto_boleta, desc_categoria_emp
from boleta 
inner join empleado
on BOLETA.numrut_emp = empleado.numrut_emp
inner join categoria_empleado
on empleado.id_categoria_emp = categoria_empleado.id_categoria_emp

 
 --Pregunta 5

 ---	Para AFP HABITAT, el porcentaje de descuento ahora será de un 13%
 update AFP set porc_descto_afp = 13 where cod_afp = 3
 

 --	Para ISAPRE VIDA TRES el porcentaje ahora es de 15 %
  update SALUD set porc_descto_salud = 15 where cod_salud = 7

  --corregir a BANMEDICA
   update SALUD set nombre_salud = 'BANMEDICA' where cod_salud = 2


--Pregunta 6


select empleado.numrut_emp, dvrut_emp, nombre_emp, appaterno_emp, count(monto_boleta) as cantidad_boletas 
from empleado 
inner join BOLETA
on empleado.numrut_emp = BOLETA.numrut_emp
where monto_boleta> 400000
group by empleado.numrut_emp, dvrut_emp, nombre_emp, appaterno_emp 


  --Pregunta 7


  select nombre_emp + ' ' + appaterno_emp + ' ' + apmaterno_emp as nombre, 
  convert(varchar(8),empleado.numrut_emp) + '-' + convert(varchar(1),dvrut_emp) as rut, 
  sueldo_base_emp, nombre_afp, nombre_salud, count(numrut_carga) as carga, asig_escolaridad.desc_escolaridad
  from empleado
  inner join AFP
  on empleado.cod_afp = AFP.cod_afp
  inner join SALUD
  on empleado.cod_salud = SALUD.cod_salud
  inner join asig_escolaridad
  on empleado.id_escolaridad = asig_escolaridad.id_escolaridad
  inner join CARGA_FAMILIAR
  on empleado.numrut_emp = CARGA_FAMILIAR.numrut_emp
  where numrut_carga> 0 and asig_escolaridad.id_escolaridad = 60 and sueldo_base_emp < 1150000 
 group by empleado.nombre_emp, empleado.appaterno_emp, empleado.apmaterno_emp, empleado.numrut_emp,empleado.dvrut_emp, sueldo_base_emp, nombre_afp,nombre_salud, asig_escolaridad.desc_escolaridad
 












