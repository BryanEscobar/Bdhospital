create database DBHospital2018026;
use DBHospital2018026;

ALTER USER 'root'@'localhost' IDENTIFIED with mysql_native_password By 'admin';


create table Medicos(
	codigoMedico int primary key auto_increment,
	licenciaMedica int,
    nombre varchar(100),
    apellido varchar(100),
    horaEntrada datetime,
    horaSalida datetime,
    sexo varchar(15)
);

create table telefonosMedico(
	codigoTelefonoMedico int primary key auto_increment,
    telefonoPersonal varchar(15) not null,
    telefonoTrabajo varchar(15) not null,
    codigoMedico int,
    Foreign key (codigoMedico) references Medicos(codigoMedico)
);

create table Horarios(
	codigoHorario int primary key auto_increment,
    horarioInicio datetime,
    horarioSalida datetime,
    lunes tinyint,
    martes tinyint,
    miercoles tinyint,
    jueves tinyint,
    viernes tinyint
);

create table Especialidades(
	codigoEspecialidad int primary key auto_increment,
    nombreEspecialidad varchar(45) not null
);

create table medicoEspecialidad(
	codigoMedicoEspecialidad int primary key auto_increment,
    codigoMedico int,
	codigoHorario int,
    codigoEspecialidad int,
    foreign key (codigoMedico) references Medicos(codigoMedico),
    foreign key (codigoHorario) references Horarios(codigoHorario),
	foreign key (codigoEspecialidad) references Especialidades(codigoEspecialidad)
);

create table Areas(
		codigoArea int primary key auto_increment,
        nombreArea varchar(45) not null
);

create table Cargos(
		codigoCargo int primary key auto_increment,
        nombreCargo varchar(45) not null
);
   
create table TurnoResponsable(
		codigoTurnoResponsable int primary key auto_increment,
        nombreResponsable varchar(75) not null,
        apellidosResponsable varchar(45) not null,
        telefonoPersonal varchar(10) not null,
        codigoArea int,
        codigoCargo int,
        foreign key (codigoArea) references Areas(codigoArea),
        foreign key (codigoCargo) references Cargos(codigoCargo)
);

create table Pacientes(
		codigoPaciente int primary key auto_increment,
        DPI varchar(20) not null,
        nombres varchar(100) not null,
        apellidos varchar(100) not null,
        fechaNacimiento date,
        edad int,
        direccion varchar(150) not null,
        ocupacion varchar(50) not null,
        sexo varchar(15) not null
);
        
        
		
        
        
create table Turno(
	codigoTurno int primary key auto_increment,
    fechaTurno date,
    fechaCita date,
    valorCita decimal (10,2),
    codigoMedicoEspecialidad int,
    codigoTurnoResponsable int,
    codigoPaciente int,
    foreign key (codigoMedicoEspecialidad) references medicoEspecialidad(codigoMedicoEspecialidad),
    foreign key (codigoTurnoResponsable) references TurnoResponsable(codigoTurnoResponsable),
    foreign key (codigoPaciente) references Pacientes (codigoPaciente)     
);



create table contactoUrgencia(
	codigocontactoUrgencia int primary key auto_increment,
    nombres varchar(100) not null,
    apellidos varchar(100) not null,
    numeroContacto varchar(10) not null,
    codigoPaciente int,
    foreign key (codigoPaciente) references Pacientes(codigoPaciente)
);

drop table ControlCitas;

create table ControlCitas(
 codigoControlCita int  primary key  auto_increment,
 fecha date not null,
 horarioInicio varchar(45) not null,
 horaFinal varchar(45) not null,
 codigoMedico int not null,
 codigoPaciente int not null,
 foreign key (codigoMedico) references Medicos(codigoMedico) on delete cascade,
 foreign key (codigoPaciente) references Pacientes(codigoPaciente)on delete cascade
 );
 
 
 
 
 create table Recetas(
 codigoReceta int primary key  auto_increment,
 descripcionReceta varchar(45),
 codigoControlCita int not null,

 foreign key (codigoControlCita) references ControlCitas(codigoControlCita) on delete cascade
 );




-- --------------------------------------------------------------------------------------------------------------------------------


--  ------------------------------------------------INFORME GENERAL-----------------------------------------------------------------

-- ---------------------------------------------------------------------------------------------------------------------------------


DELIMITER $$

create procedure sp_MedicoHorarios (in p_codigoMedico int)
BEGIN
select h.* from Horarios h 
inner join MedicoEspecialidad me on h.codigoHorario = me.codigoMedicoEspecialidad 
where me.codigoMedico = p_codigoMedico;


create view vReporteGeneral as select m.*, h.lunes, h.martes, h.miercoles, h.jueves, h.viernes, e.nombreEspecialidad, 
p.DPI, p.nombres as nombresPacientes, p.apellidos as apellidosPacientes, p.fechaNacimiento, p.edad, p.direccion,
p.ocupacion, p.sexo as sexoPacientes, tr.nombreResponsable, tr.apellidosResponsable, tr.telefonoPersonal, c.nombreCargo, a.nombreArea
from Medicos m inner join medicoEspecialidad me  on me.codigoMedico = m.codigoMedico
inner join Especialidades e on e.codigoEspecialidad = me.codigoEspecialidad
inner join horarios h on h.codigoHorario = me.codigoHorario
left join Turno t on t.codigoMedicoEspecialidad = me.codigoMedicoEspecialidad
left join pacientes p on p.codigoPaciente = t.codigoPaciente
left join TurnoResponsable tr	on tr.codigoTurnoResponsable = t.codigoTurnoResponsable
left join cargos c on c.codigoCargo = tr.codigoCargo
left join areas a  on a.codigoArea = tr.codigoArea;

END$$
DELIMITER ;





-- **************************************************************PROCEDIMIENTOS DE MEDICOS*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_Medicos(p_licenciaMedica int,p_nombre varchar(100),p_apellido varchar(100),p_horaEntrada datetime,p_horaSalida datetime,p_sexo varchar(15))
Begin
Insert into Medicos(licenciaMedica,nombre,apellido,horaEntrada,horaSalida,sexo)
values(p_licenciaMedica,p_nombre,p_apellido,p_horaEntrada,p_horaSalida,p_sexo);
End $$ 
delimiter ;

call sp_agregar_Medicos(2365,'Jose Gerardo','Escobar Fuentes','2019-05-28 8:00:00','2019-05-28 18:00:00','Masculino');
call sp_agregar_Medicos(8569,'Marielos','Perez Avila','2019-05-29 5:00:00','2019-05-29 20:00:00','Femenino');
call sp_agregar_Medicos(2569,'Luisa Fernanda','Garrido Montufar','2019-05-30 10:00:00','2019-05-30 23:30:00','Femenino');
call sp_agregar_Medicos(1023,'Anderson','Coronado Castillo','2019-05-30 1:30:00','2019-05-30 1:00:00','Masculino');
call sp_agregar_Medicos(3658,'Edgar Steven','Echeverria Cifuentes','2019-05-31 20:00:00','2019-06-01 8:30:00','Masculino');



-- ***************************************************************************************************************************************************************************************************************************************************************************************


DELIMITER $$
create procedure sp_modificar_Medicos(p_codigoMedico int,p_licenciaMedica int,p_nombre varchar(100),p_apellido varchar(100),p_horaEntrada datetime,p_horaSalida datetime,p_sexo varchar(15))
BEGIN
update Medicos
	set licenciaMedica = p_licenciaMedica, nombre = p_nombre, apellido=p_apellido,horaEntrada=p_horaEntrada,horaSalida = p_horaSalida,sexo=p_sexo
    where codigoMedico= p_codigoMedico;
END $$
delimiter ;

call sp_modificar_Medicos(2,4028,'Bryan Adrian','Escobar ','2019-06-02 7:00:00','2019-06-02 20:30:00','Hombre');
call sp_modificar_Medicos(1,3086,'Luis Estuardo',' Menendez','2019-06-02 7:00:00','2019-06-02 20:30:00','Hombre');
call sp_modificar_Medicos(5,6078,'Dennia Lucrecia','Contreras','2019-06-02 7:00:00','2019-06-02 20:30:00','Femenino');


-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_Medicos(p_codigoMedico int)
BEGIN
delete from Medicos where codigoMedico = p_codigoMedico;
END $$
delimiter ;

call sp_eliminar_Medicos(1);

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_Medicos(p_codigoMedico int )
BEGIN 
select * from Medicos where codigoMedico=p_codigoMedico;
end $$

	call sp_buscar_Medicos(1);
    select * from Medicos;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_Medicos()
BEGIN 
	select codigoMedico,licenciaMedica,nombre,apellido,horaEntrada,horaSalida,sexo from Medicos;
end $$

	call sp_listar_Medicos()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from Medicos;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- **************************************************************PROCEDIMIENTOS DE TELEFONOS MEDICOS*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_telefonosMedico(p_telefonoPersonal varchar(15),p_telefonoTrabajo varchar(15),p_codigoMedico int)
Begin
Insert into telefonosMedico(telefonoPersonal,telefonoTrabajo,codigoMedico)
values(p_telefonoPersonal,p_telefonoTrabajo,p_codigoMedico);
End $$ 
delimiter ;

	call sp_agregar_telefonosMedico('4028-3276','2204-8975',1);
	call sp_agregar_telefonosMedico('3236-2085','2487-5602',2);
	call sp_agregar_telefonosMedico('5682-5478','2365-4561',3);
	call sp_agregar_telefonosMedico('5067-7713','2000-2365',4);
	call sp_agregar_telefonosMedico('5548-0258','2289-7402',5);
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************


DELIMITER $$
create procedure sp_modificar_telefonosMedico(p_codigoTelefonoMedico int, p_telefonoPersonal varchar(15),p_telefonoTrabajo varchar(15),p_codigoMedico int)
BEGIN
update telefonosMedico
	set telefonoPersonal=p_telefonoPersonal,telefonoTrabajo=p_telefonoTrabajo,codigoMedico=p_codigoMedico
    where codigoTelefonoMedico=p_codigoTelefonoMedico;
END $$
delimiter ;
		
	call sp_modificar_telefonosMedico(1,'3285-4602','2206-8974',1);
	call sp_modificar_telefonosMedico(3,'9802-3256','2875-6598',3);
	call sp_modificar_telefonosMedico(5,'7854-8945','2638-9812',5);
	

-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_telefonosMedico(p_codigotelefonoMedico int )
BEGIN
delete from telefonosMedico where codigotelefonoMedico=p_codigotelefonoMedico;
END $$
delimiter ;

		call sp_eliminar_telefonosMedico(3);
        
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_telefonosMedico(p_codigotelefonoMedico int )
BEGIN 
select * from telefonosMedico where codigotelefonoMedico=p_codigotelefonoMedico;
end $$


	call sp_buscar_telefonosMedico(1);
    select * from telefonosMedico;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_telefonosMedico()
BEGIN 
	select codigotelefonoMedico,telefonoPersonal,telefonoTrabajo,codigoMedico from telefonosMedico;
end $$

	call sp_listar_telefonosMedico()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from telefonosMedico;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        
        
        



-- **************************************************************PROCEDIMIENTOS DE HORARIOS*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_Horarios(p_horarioInicio datetime,p_horarioSalida datetime,p_lunes tinyint,p_martes tinyint,p_miercoles tinyint,
	p_jueves tinyint, p_viernes tinyint)
Begin
Insert into Horarios(horarioInicio,horarioSalida,lunes,martes,miercoles,jueves,viernes )
values(p_horarioInicio ,p_horarioSalida,p_lunes,p_martes,p_miercoles,p_jueves,p_viernes);
End $$ 
delimiter ;

	call sp_agregar_Horarios('2019-06-12 7:00:00','2019-06-12 20:00:00',1,2,3,4,5);
	call sp_agregar_Horarios('2019-04-01 5:30:00','2019-04-01 01:00:00',5,1,2,2,1);
	call sp_agregar_Horarios('2019-06-20 6:00:00','2019-06-21 07:00:00',1,5,3,4,4);
	call sp_agregar_Horarios('2019-07-08 11:00:00','2019-07-09 2:00:00',6,9,4,1,1);
	call sp_agregar_Horarios('2019-06-16 8:00:00','2019-06-16 20:00:00',1,2,3,4,4);
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************
  
DELIMITER $$
create procedure sp_modificar_Horarios(p_codigoHorario int, p_horarioInicio datetime,p_horarioSalida datetime,p_lunes tinyint,p_martes tinyint,p_miercoles tinyint,
	p_jueves tinyint, p_viernes tinyint)
BEGIN
update Horarios
	set  horarioInicio=p_horarioInicio ,horarioSalida=p_horarioSalida,lunes=p_lunes,martes=p_martes,miercoles=p_miercoles,jueves=p_jueves,viernes=p_viernes 
    where codigoHorario=p_codigoHorario;
END $$
delimiter ;
		
    call sp_modificar_Horarios(1,'2019-07-12 14:00:00','2019-06-12 20:00:00',1,2,3,4,5);
    call sp_modificar_Horarios(3,'2019-06-14 13:00:00','2019-06-15 14:00:00',3,2,3,4,3);
    call sp_modificar_Horarios(5,'2019-06-22 09:00:00','2019-06-22 21:00:00',2,2,3,4,5);
    
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_Horarios(p_codigoHorario int )
BEGIN
delete from Horarios where codigoHorario=p_codigoHorario;
END $$
delimiter ;

	call sp_eliminar_Horarios(1);
    
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_Horarios(p_codigoHorario int )
BEGIN 
select * from Horarios where codigoHorario=p_codigoHorario;
end $$

	call sp_buscar_Horarios(1);
    select * from Horarios;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_Horarios()
BEGIN 
	select codigoHorario,horarioInicio,horarioSalida,lunes,martes,miercoles,jueves,viernes from Horarios;
end $$

	call sp_listar_Horarios()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from Horarios;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    
    




    
-- **************************************************************PROCEDIMIENTOS DE ESPECIALIDADES*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_Especialidades(p_nombreEspecialidad varchar(45))
Begin
Insert into Especialidades(nombreEspecialidad)
values(p_nombreEspecialidad);
End $$ 
delimiter ;

	call sp_agregar_Especialidades('Pediatria');
    call sp_agregar_Especialidades('Cardiologia');
    call sp_agregar_Especialidades('Psiquiatría');
    call sp_agregar_Especialidades('Neurología');
    call sp_agregar_Especialidades('Nefrología');
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_Especialidades(p_codigoEspecialidad int,p_nombreEspecialidad varchar(45))
BEGIN
update Especialidades
	set nombreEspecialidad=p_nombreEspecialidad 
    where codigoEspecialidad=p_codigoEspecialidad;
END $$
delimiter ;  
    
    call sp_modificar_Especialidades(5,'Oftalmología');
    call sp_modificar_Especialidades(3,'Hematología y hemoterapia');
    call sp_modificar_Especialidades(1,'Endocrinología');
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_Especialidades(p_codigoEspecialidad int )
BEGIN
delete from Especialidades where codigoEspecialidad=p_codigoEspecialidad;
END $$
delimiter ;

	call sp_eliminar_Especialidades(4);
    
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_Especialidades(p_codigoEspecialidad int )
BEGIN 
select * from Especialidades where codigoEspecialidad=p_codigoEspecialidad;
end $$


	call sp_buscar_Especialidades(1);
    select * from Especialidades;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_Especialidades()
BEGIN 
	select codigoEspecialidad,nombreEspecialidad from Especialidades;
end $$

	call sp_listar_Especialidades()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from Especialidades;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////





drop procedure  sp_agregar_medicoEspecialidad;

-- **************************************************************PROCEDIMIENTOS DE MEDICO ESPECIALIDAD*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_medicoEspecialidad(p_codigoMedico int, p_codigoHorario int, p_codigoEspecialidad int)
Begin
Insert into medicoEspecialidad(codigoMedico,codigoHorario,codigoEspecialidad)
values(p_codigoMedico, p_codigoHorario, p_codigoEspecialidad);
End $$ 
delimiter ;

		call sp_agregar_medicoEspecialidad(3,2,5);
        call sp_agregar_medicoEspecialidad(2,5,4);
        call sp_agregar_medicoEspecialidad(1,4,3);
        call sp_agregar_medicoEspecialidad(5,1,1);
        call sp_agregar_medicoEspecialidad(4,3,2);

-- ***************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_medicoEspecialidad(p_codigoMedicoEspecialidad int, p_codigoMedico int, p_codigoHorario int, p_codigoEspecialidad int)
BEGIN
update medicoEspecialidad
	set codigoMedico=p_codigoMedico,codigoHorario=p_codigoHorario,codigoEspecialidad=p_codigoEspecialidad
    where codigoMedicoEspecialidad=p_codigoMedicoEspecialidad;
END $$
delimiter ; 
    
    call sp_modificar_medicoEspecialidad(1,2,2,2);
    call sp_modificar_medicoEspecialidad(3,5,2,1);
    call sp_modificar_medicoEspecialidad(5,3,3,2);

-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_medicoEspecialidad(p_codigoMedicoEspecialidad int )
BEGIN
delete from medicoEspecialidad where codigoMedicoEspecialidad=p_codigoMedicoEspecialidad;
END $$
delimiter ;

		call sp_eliminar_medicoEspecialidad(2);
        
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************
-- drop procedure  sp_buscar_medicoEspecialidad;

Delimiter $$
create procedure sp_buscar_medicoEspecialidad(p_codigoMedicoEspecialidad int )
BEGIN 
select * from medicoEspecialidad where codigoMedicoEspecialidad=p_codigoMedicoEspecialidad;
end $$

	call sp_buscar_medicoEspecialidad(1);
    select * from medicoEspecialidad;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_medicoEspecialidad()
BEGIN 
	select codigoMedicoEspecialidad,codigoMedico,codigoHorario,codigoEspecialidad from medicoEspecialidad;
end $$

	call sp_listar_EsmedicoEspecialidad()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from medicoEspecialidad;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        
 
 
        

-- **************************************************************PROCEDIMIENTOS DE AREAS*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_Areas(p_nombreArea varchar(45))
Begin
Insert into Areas(nombreArea)
values(p_nombreArea);
End $$ 
delimiter ;

		call sp_agregar_Areas('Pediatria');
        call sp_agregar_Areas('Cardiologia');
        call sp_agregar_Areas('Psiquiatría');
        call sp_agregar_Areas('Neurología');
        call sp_agregar_Areas('Nefrología');
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_Areas(p_codigoArea int,p_nombreArea varchar(45))
BEGIN
update Areas
	set nombreArea=p_nombreArea
    where codigoArea=p_codigoArea;
END $$
delimiter ;  

		call p_modificar_Areas(5,'Oftalmología');
		call p_modificar_Areas(3,'Hematología y hemoterapia');
        call p_modificar_Areas(1,'Endocrinología');
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_Areas(p_codigoArea int )
BEGIN
delete from Areas where codigoArea=p_codigoArea;
END $$
delimiter ;

		call sp_eliminar_Areas(5);
        
        
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_Areas(p_codigoArea int )
BEGIN 
select * from Areas where codigoArea=p_codigoArea;
end $$

	call sp_buscar_Areas(1);
    select * from Areas;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_Areas()
BEGIN 
	select codigoArea,nombreArea from Areas;
end $$

	call sp_listar_Areas()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from Areas;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        


        
-- **************************************************************PROCEDIMIENTOS DE CARGOS*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_Cargos(p_nombreCargo varchar(45))
Begin
Insert into Cargos(nombreCargo)
values(p_nombreCargo);
End $$ 
delimiter ;      
        
        call sp_agregar_Cargos('Jefatura de encamamiento');
        call sp_agregar_Cargos('Jefatura de Cardiologia  ');
        call sp_agregar_Cargos('Jefatura de Psiquiatría');
        call sp_agregar_Cargos('Sub director de Neurología');
        call sp_agregar_Cargos('supervisor de turno de Nefrología');
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_Cargos(p_codigoCargo int,p_nombreCargo varchar(45))
BEGIN
update Cargos
	set nombreCargo=p_nombreCargo
    where codigoCargo=p_codigoCargo;
END $$
delimiter ;  
        
        call sp_modificar_Cargos('Director de Neurología');
        call sp_modificar_Cargos('Jefatura de Pediatria');
        call sp_modificar_Cargos('Encargado de myaores de Psiquiatría');
        
 -- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_Cargos(p_codigoCargo int )
BEGIN
delete from Cargos where codigoCargo=p_codigoCargo;
END $$ 
        call sp_eliminar_Cargos(1);
        
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_Cargos(p_codigoCargo int )
BEGIN 
select * from Cargos where codigoCargo=p_codigoCargo;
end $$

	call sp_buscar_Cargos(1);
    select * from Cargos;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_Cargos()
BEGIN 
	select codigoCargo,nombreCargo from Cargos;
end $$

	call sp_listar_Cargos()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from Areas;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        
 
 
        
        
 -- **************************************************************PROCEDIMIENTOS DE TURNOS RESPONSABLES*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_turnoResponsable(p_nombreResponsable varchar(75),p_apellidosResponsable varchar(45),p_telefonoPersonal varchar(10),
p_codigoArea int,p_codigoCargo int )
Begin
Insert into turnoResponsable(nombreResponsable ,apellidosResponsable,telefonoPersonal,codigoArea,codigoCargo)
values(p_nombreResponsable,p_apellidosResponsable,p_telefonoPersonal,p_codigoArea,p_codigoCargo);
End $$ 
delimiter ;         
        
        call sp_agregar_turnoResponsable('Jose Gerardo','Escobar Fuentes','4028-3276',1,1);
        call sp_agregar_turnoResponsable('Marielos','Perez Avila','3236-2085',2,2);
        call sp_agregar_turnoResponsable('Luisa Fernanda','Garrido Montufar','5682-5478',3,3);		
        call sp_agregar_turnoResponsable('Anderson','Coronado Castillo','5067-7713',2,1);
        call sp_agregar_turnoResponsable('Edgar Steven','Echeverria Cifuentes','5548-0258',5,4);
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_turnoResponsable(p_codigoTurnoResponsable int, p_nombreResponsable varchar(75),p_apellidosResponsable varchar(45),p_telefonoPersonal varchar(10),
p_codigoArea int,p_codigoCargo int)
BEGIN
update turnoResponsable
	set nombreResponsable=p_nombreResponsable,apellidosResponsable=p_apellidosResponsable,telefonoPersonal=p_telefonoPersonal,codigoArea=p_codigoArea ,codigoCargo=p_codigoCargo
    where codigoturnoResponsable=p_codigoturnoResponsable;
END $$
delimiter ;  
        
        call sp_modificar_turnoResponsable(1,'Bryan',' Escobar''3285-4602',2);		
        call sp_modificar_turnoResponsable(3,'Dennia Lucrecia','Contreras','9802-3256',1);
        call sp_modificar_turnoResponsable(5,'Luis Estuardo',' Menendez''7854-8945',5);
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_turnoResponsable(p_codigoturnoResponsable int )
BEGIN
delete from turnoResponsable where codigoturnoResponsable=p_codigoturnoResponsable;
END $$
delimiter ;         
        
        call sp_eliminar_turnoResponsable(2);
        
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_turnoResponsable(p_codigoturnoResponsable int )
BEGIN 
select * from turnoResponsable where codigoturnoResponsable=p_codigoturnoResponsable;
end $$

	call sp_buscar_turnoResponsable(1);
    select * from turnoResponsable;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_turnoResponsable()
BEGIN 
	select codigoturnoResponsable,nombreResponsable ,apellidosResponsable,telefonoPersonal,codigoArea,codigoCargo from turnoResponsable;
end $$

	call sp_listar_turnoResponsable()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from turnoResponsable;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



     
     
        
-- **************************************************************PROCEDIMIENTOS DE PACIENTES*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_Pacientes(p_DPI varchar(20),p_nombres varchar(100),p_apellidos varchar(100),p_fechaNacimiento date,
p_edad int, p_direccion varchar(150),p_ocupacion varchar(50),p_sexo varchar(15))
Begin
Insert into Pacientes(DPI,nombres,apellidos,fechaNacimiento,edad,direccion,ocupacion,sexo)
values(p_DPI,p_nombres,p_apellidos,p_fechaNacimiento,p_edad,p_direccion,p_ocupacion,p_sexo);
End $$ 
delimiter ;   

	call sp_agregar_Pacientes('1452 7895 0101','Luis','Suchite','1992-06-01',30,'4ta calle 78-25 zona 1','chofer','Masculino');
	call sp_agregar_Pacientes('2365 4592 0101','Jose','Contreras','1996-02-10',23,'15av 00-05 zona 2','Profesor','Masculino');
	call sp_agregar_Pacientes('2561 4621 0101','Dennia','Escobar','1992-05-29',23,'4ta calle 30-07 col.Galiea zona 18','Profesora','Femenino');
	call sp_agregar_Pacientes('1236 5897 0101','Steven','Escobar','1995-11-27',25,'4ta calle 30-07 col.Galiea zona 18','lic. en Telecomunicaciones','Masculino');
	call sp_agregar_Pacientes('1569 5458 0101','Deyvid','Estrada','1999-08-20',20,'casa 29 arco 3 zona 5','Mecanico','Masculino');
	call sp_agregar_Pacientes('8952 9567 0101','Luis','tun','1995-04-16',27,'30 calle zona 1','Dentista','Masculino');
   
   
-- ***************************************************************************************************************************************************************************************************************************************************************************************
DELIMITER $$
create procedure sp_modificar_Pacientes(p_codigoPaciente int, p_DPI varchar(20),p_nombres varchar(100),p_apellidos varchar(100),p_fechaNacimiento date,
p_edad int, p_direccion varchar(150),p_ocupacion varchar(50),p_sexo varchar(15))
BEGIN
update Pacientes
	set DPI=p_DPI,nombres=p_nombres,apellidos=p_apellidos,fechaNacimiento=p_fechaNacimiento,edad=p_edad,direccion=p_direccion,ocupacion=p_ocupacion,sexo=p_sexo
    where codigoPaciente=p_codigoPaciente;
END $$
delimiter ;  

	call sp_modificar_Pacientes(5,'2364 4568 0101','Delia','Menendez','1942-01-22',46,'3ra calle los Olivos zona','lic. en Educacion','Femenino');
    call sp_modificar_Pacientes(2,'9845 5897 0101','Carlos','Fuentes','1990-02-29',28,'Casa 35 arco 3 zona 5','Mecanico','Masculino');
    call sp_modificar_Pacientes(4,'1236 5642 0101','Cory','Maldonado','1968-12-01',38,'lomas del Norte zona 17','Secretaria','Femenino');
        
        
-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_Pacientes(p_codigoPaciente int )
BEGIN
delete from Pacientes where codigoPaciente=p_codigoPaciente;
END $$
delimiter ;            

	call sp_eliminar_Pacientes(3);


-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_buscar_Pacientes(p_codigoPaciente int )
BEGIN 
select * from Pacientes where codigoPaciente=p_codigoPaciente;
end $$

	call sp_buscar_Pacientes(1);
    select * from Pacientes;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_Pacientes()
BEGIN 
	select codigoPaciente,DPI,nombres,apellidos,fechaNacimiento,edad,direccion,ocupacion,sexo from Pacientes;
end $$

	call sp_listar_Pacientes()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from Pacientes;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



-- **************************************************************PROCEDIMIENTOS DE TURNO*************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_Turno(p_fechaTurno date,p_fechaCita date,p_valorCita decimal(10,2),p_codigoMedicoEspecialidad int,p_codigoTurnoResponsable int,p_codigoPaciente int )
Begin
Insert into Turno(fechaTurno,fechaCita,valorCita,codigoMedicoEspecialidad,codigoTurnoResponsable,codigoPaciente)
values(p_fechaTurno,p_fechaCita,p_valorCita,p_codigoMedicoEspecialidad,p_codigoTurnoResponsable,p_codigoPaciente);
End $$ 
delimiter ;  

	call sp_agregar_Turno('2019-03-12','2019-03-12',200.00,1,1,3);
    call sp_agregar_Turno('2019-06-10','2019-06-10',150.00,2,2,1);
    call sp_agregar_Turno('2019-07-04','2019-07-04',100.00,2,3,2);
	call sp_agregar_Turno('2019-08-16','2019-08-16',50.00,3,4,5);
    call sp_agregar_Turno('2019-06-20','2019-06-20',350.00,2,5,4);


-- ***************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_Turno(p_codigoTurno int, p_fechaTurno date,p_fechaCita date,p_valorCita decimal(10,2),p_codigoMedicoEspecialidad int,p_codigoTurnoResponsable int,p_codigoPaciente int)
BEGIN
update Turno
	set fechaTurno=p_fechaTurno,fechaCita=p_fechaCita,valorCita=p_valorCita,codigoMedicoEspecialidad=p_codigoMedicoEspecialidad ,codigoTurnoResponsable=p_codigoTurnoResponsable,codigoPaciente=p_codigoPaciente 
    where codigoTurno=p_codigoTurno;
END $$
delimiter ;  


	call sp_modificar_Turno(1,'2019-10-10','2019-10-10',160.00,1,3,2);
    call sp_modificar_Turno(3,'2019-09-25','2019-09-25',250.00,5,4,1);
	call sp_modificar_Turno(5,'2019-08-16','2019-08-16',100.00,3,5,1);


-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_Turno(p_codigoTurno int )
BEGIN
delete from Turno where codigoTurno=p_codigoTurno;
END $$
delimiter ;    

	call sp_eliminar_Turno(5);
    
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_Turno(p_codigoTurno int )
BEGIN 
select * from Turno where codigoTurno=p_codigoTurno;
end $$


	call sp_buscar_Turno(1);
    select * from Turno;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_Turno()
BEGIN 
	select codigoTurno,fechaTurno,fechaCita,valorCita,codigoMedicoEspecialidad,codigoTurnoResponsable,codigoPaciente from Turno;
end $$

	call sp_listar_Turno()
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		select * from Turno;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////







-- **************************************************************PROCEDIMIENTOS DE *CONTACTO URGENCIA************************************************************************************************************************************************************************************************************************
DELIMITER  $$
create procedure sp_agregar_contactoUrgencia(p_nombres varchar(100),p_apellidos varchar(100),p_numeroContacto varchar(10),p_codigoPaciente int)
Begin
Insert into contactoUrgencia(nombres,apellidos,numeroContacto,codigoPaciente)
values(p_nombres,p_apellidos,p_numeroContacto,p_codigoPaciente);
End $$ 
delimiter ;      

	call sp_agregar_contactoUrgencia('Josue','Martinez','5068-8974',2);
    call sp_agregar_contactoUrgencia('Lucia','Ovalle','3038-9802',1);
    call sp_agregar_contactoUrgencia('Luis','Archila','5696-5962',3);
    call sp_agregar_contactoUrgencia('Sebastian','Arceo','3038-9802',5);
	call sp_agregar_contactoUrgencia('Simon','Perez','7856-2013',4);
    
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_contactoUrgencia(p_codigocontactoUrgencia int,p_nombres varchar(100),p_apellidos varchar(100),p_numeroContacto varchar(10),p_codigoPaciente int)
BEGIN
update contactoUrgencia
	set nombres=p_nombres,apellidos=p_apellidos,numeroContacto=p_numeroContacto,codigoPaciente=p_codigoPaciente 
    where codigocontactoUrgencia=p_codigocontactoUrgencia;
END $$
delimiter ;  


	call sp_modificar_contactoUrgencia(1,'Edgar','Cortez','5930-8324',4);
    call sp_modificar_contactoUrgencia(5,'A;ejandro','Perez','4569-8231',3);
    call sp_modificar_contactoUrgencia(3,'Jhosua','Alonso','9562-3147',2);


-- ***************************************************************************************************************************************************************************************************************************************************************************************

Delimiter $$
create procedure sp_eliminar_contactoUrgencia(p_codigocontactoUrgencia int )
BEGIN
delete from contactoUrgencia where codigocontactoUrgencia=p_codigocontactoUrgencia;
END $$
delimiter ;    

	call sp_eliminar_contactoUrgencia(2);
    
    
    
-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_buscar_contactoUrgencia(p_codigocontactoUrgencia int )
BEGIN 
select * from contactoUrgencia where codigocontactoUrgencia=p_codigocontactoUrgencia;
end $$


	call sp_buscar_contactoUrgencia(1);
    select * from contactoUrgencia;

-- ***************************************************************************************************************************************************************************************************************************************************************************************


Delimiter $$
create procedure sp_listar_contactoUrgencia()
BEGIN 
	select codigocontactoUrgencia,nombres,apellidos,numeroContacto,codigoPaciente from contactoUrgencia;
end $$

	call sp_listar_contactoUrgencia()
    
    
    
    
    
    
    
    
    
    
    drop procedure sp_modificar_ControlCitas;

-- ************************************************************************PROCEDIMIENTOS DE CONTROL DE CITAS ****************************************************************************************************************************************************************************
 DELIMITER  $$
 create procedure sp_agregar_ControlCitas(p_fecha date, p_horarioInicio varchar(45),p_horaFinal varchar(45),codigoMedico int, codigoPaciente int)
 begin
 insert into ControlCitas( fecha, horarioInicio, horaFinal,codigoMedico,codigoPaciente)
values(p_fecha,p_horarioInicio,p_horaFinal,codigoMedico,codigoPaciente);
 end$$
delimiter ;

	call sp_agregar_controlCitas('2019-07-23','07:00:00','07:30:00',1,1);
	call sp_agregar_controlCitas('2019-07-25','10:05:00','10:35:00',2,3);
    call sp_agregar_controlCitas('2019-08-01','12:00:00','12:25:00',3,4);

drop procedure sp_modificar_controlCitas;

-- *******************************************************************************************************************************************************************************************************************************************************************************************
DELIMITER $$ 
create procedure sp_modificar_ControlCitas(p_codigoControlCita int, p_fecha date,p_horarioInicio varchar(45),p_horaFinal varchar(45),p_codigoMedico int,p_codigoPaciente int)
begin
	update ControlCitas
    set fecha=p_fecha, horarioInicio=p_horarioInicio, horaFinal=p_horaFinal, codigoMedico=p_codigoMedico,
codigoPaciente=p_codigoPaciente
		where codigoControlCita=p_codigoControlCita;
end $$
delimiter ;

	call sp_modificar_controlCitas(1,'2019-07-24','14:15:00','14:30:00',5,4);
    
    drop procedure sp_eliminar_ContrlCitas;
-- ********************************************************************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_eliminar_ControlCitas(p_codigoControlCita int)
begin
	delete from ControlCitas
		where codigoControlCita=p_codigoControlCita;
end$$
delimiter ;

		call sp_eliminar_controlCitas(2);
        
        
        
        
        
-- **********************************************************************************************************************************************************************************************************************************************************************************************
DELIMITER $$
  create procedure sp_buscar_ControlCitas(p_codigoControlCita int)
  begin
	  select * from ControlCitas
		where codigoControlCita=p_codigoControlCita;
	end$$


			call sp_buscar_controlCitas(1);


drop procedure sp_listar_controlCitas;
--  **********************************************************************************************************************************************************************************************************************************************************************************************
DELIMITER $$
 create procedure sp_listar_ControlCitas()
 begin
	 select codigoControlCita,fecha,horarioInicio,horaFinal,codigoMedico,codigoPaciente from ControlCitas;
 end$$

		call sp_listar_controlCitas()
        
        
select * from controlCitas;


















drop procedure sp_agregar_Recetas;
-- ************************************************************* PROCEDIMIENTOS DE RECETAS ****************************************************************************************************************************************
DELIMITER $$
 create procedure sp_agregar_Recetas(p_descripcionReceta varchar(45),p_codigoControlCita varchar(45))
 begin
	insert into Recetas(descripcionReceta,codigoControlCita)
		values(p_descripcionReceta,p_codigoControlCita);
 end$$
delimiter ;

		call sp_agregar_Recetas('2 paracetamol coda 12H.',1);
        call sp_agregar_Recetas('1 blister de doloneurobion 1 capsula cada 12H',2);
        call sp_agregar_Recetas('1 blister de tapcin noche 1 capsula cada 12H',3);
        
-- **********************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_modificar_Recetas(p_codigoReceta int, p_descripcionReceta varchar(45), p_codigoControlCita int)
begin
	update Recetas
    set descripcionReceta=p_descripcionReceta, codigoControlCita=p_codigoControlCita
		where codigoReceta=p_codigoReceta;
end$$
delimiter ;

		call sp_modificar_Recetas(2,'1 suero anti derrico, 1 cucharada cada 6H',1);
        
        
-- ************************************************************************************************************************************************************************************************************************************

DELIMITER $$
create procedure sp_eliminar_Recetas(p_codigoReceta int)
begin 
	delete from Recetas
		where codigoReceta=p_codigoReceta;
end$$
delimiter ;
   
   
		call sp_eliminar_Recetas(1);
        
        
        
-- ************************************************************************************************************************************************************************************************************************************


DELIMITER $$
  create procedure sp_buscar_Recetas(p_codigoReceta int)
  begin
	select * from Recetas
		where codigoReceta=p_codigoReceta;
  end$$
		call sp_buscar_Recetas(1);
        
        
        
-- ***************************************************************************************************************************************************************************************************************************************         
 
DELIMITER $$
create procedure sp_listar_Recetas()
 begin
	select codigoReceta,descripcionReceta,codigoControlCita from Recetas;
 end$$


	call sp_listar_Recetas()


    
    
    
    
    
    
    
    

-- ***************************************************************************************************************************************************************************************************************************************************************************************
		-- select  * from contactoUrgencia;
-- ***************************************************************************************************************************************************************************************************************************************************************************************

-- ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


-- drop database DBHospital2018026;
