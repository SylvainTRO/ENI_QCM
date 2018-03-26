Use master;
go
if DB_ID('BDD_QCM') is not null
	drop database BDD_QCM;
go
create database BDD_QCM;
go
Use BDD_QCM;

create table Questions(
id_question int not null identity(1,1) primary key,
libelle text not null, 
type varchar(30) not null,
fichier_image varchar(255),
id_theme int not null
);
go
 
 create table Questions_user(
 id_question int unique not null,
 id_epreuve int unique not null,
 num_question int unique not null,
 marque bit
 );

 create table Reponses(
 id_reponse int not null identity(1,1) primary key,
 id_question int not null,
 libelle text not null,
 correct bit not null, 
 );
 go

 create table Reponses_user(
 id_reponse int unique not null,
 id_question int unique not null,
 id_epreuve int unique not null,
 );

 create table Themes(
 id_theme int not null identity(1,1) primary key,
 nom varchar(255) unique not null,
 );
 go

 create table Sections(
 id_section int not null identity(1,1) primary key,
 nom varchar(255) not null,
 id_theme int not null,
 id_qcm int not null,
 nb_questions int not null 
 );
 go



 create table Qcms(
 id_qcm int not null identity(1,1) primary key,
 nom varchar(255) not null,
 niveau varchar(255) not null,  
 );

 go
 create table Sessions(
 id_session int not null identity(1,1) primary key,
 id_user  int not null,
 id_qcm int not null,
 date_inscription datetime not null,
 temps_limite int not null,
 date_prevue datetime not null,
 resultat int null
 );
 go



 create table Epreuves(
 id_epreuve int not null identity(1,1) primary key,
 date_passage datetime not null,
 temps_restant int not null,
 id_session int not null
 );

 create table Users(
 id_user int not null identity(1,1) primary key,
 login varchar(255) not null, 
 password varchar(255) not null,
 nom varchar(255) not null,
 prenom varchar(255) not null,
 email varchar(255) not null,
 role char(3) not null,
 id_promo int null
 );
 go

 create table Roles(
 codeRole char(3) primary key,
 libelle varchar(255) not null
 );

 create table Promotions(
 id_promo int not null identity(1,1) primary key,
 nom varchar(255)
 );
 go


alter table Reponses add constraint fk_reponse_question foreign key (id_question) references Questions (id_question);
alter table Questions add constraint fk_question_theme foreign key (id_theme) references Themes (id_theme);
alter table Sections add constraint fk_theme_section foreign key (id_theme) references Themes (id_theme);
alter table Sections add constraint fk_qcm_section foreign key (id_qcm) references Qcms (id_qcm);
alter table Sessions add constraint fk_user_session foreign key (id_user) references Users (id_user);
alter table Sessions add constraint fk_qcm_session foreign key (id_qcm) references Qcms (id_qcm);
alter table Users add constraint fk_promotion_user foreign key (id_promo) references Promotions (id_promo);
alter table Epreuves add constraint fk_session_epreuve foreign key (id_session) references Sessions (id_session);
alter table Questions_user add constraint fk_questionU_question foreign key (id_question) references Questions (id_question);
alter table Questions_user add constraint fk_questionU_epreuve foreign key (id_epreuve) references Epreuves (id_epreuve);
alter table Reponses_user add constraint fk_1 foreign key (id_reponse) references Reponses (id_reponse); 
alter table Reponses_user add constraint fk_2 foreign key (id_question) references Questions (id_question); 
alter table Reponses_user add constraint fk_3 foreign key (id_epreuve) references Epreuves (id_epreuve); 


insert into Promotions(nom) values ('DL-127');
insert into Promotions(nom) values ('CDI-72');

insert into Roles (codeRole, libelle) values ('STA', 'stagiaire');
insert into Roles (codeRole, libelle) values ('FOR', 'formateur');
insert into Roles (codeRole, libelle) values ('CAN', 'candidat');
insert into Roles (codeRole, libelle) values ('RES', 'responsable de formation');

insert into Users(login, password, nom, prenom, email, role) values ('michel', 'michel', 'Michel', 'DUPONT', 'michel@hotmail.fr', 'STA');
insert into Users(login, password, nom, prenom, email, role) values ('micheline', 'micheline', 'Micheline', 'DUPOND', 'micheline@hotmail.fr', 'CAN');
insert into Users(login, password, nom, prenom, email, role) values ('fabrice', 'fabrice', 'fabrice', 'FARRUGIA', 'fabrice@hotmail.fr', 'FOR');
insert into Users(login, password, nom, prenom, email, role) values ('robert', 'robert', 'Robert', 'Rourour', 'robert@hotmail.fr', 'RES');

insert into Themes (nom) values ('Java EE');
insert into Themes (nom) values ('Php');
insert into Themes (nom) values ('Java SE');
insert into Themes (nom) values ('SQL Server');

insert into Questions (libelle, type, fichier_image, id_theme) values ('A quoi sert une Servlet ?', 'unique', null, 1);
insert into Questions (libelle, type, fichier_image, id_theme) values ('A quoi sert une JSP ?', 'multiple', null, 1);
insert into Questions (libelle, type, fichier_image, id_theme) values ('Lesquelles sont des balises HTML ?', 'multiple', null, 1);
insert into Questions (libelle, type, fichier_image, id_theme) values ('Que veut dire le EE de Java EE ?', 'unique', null, 1);

insert into Questions (libelle, type, fichier_image, id_theme) values ('Quel est le framework le plus courant en php ?', 'unique', null, 2);
insert into Questions (libelle, type, fichier_image, id_theme) values ('Par quoi commence forcément une variable Php', 'unique', null, 2);
insert into Questions (libelle, type, fichier_image, id_theme) values ('Cochez les types primitif en php', 'multiple', null, 2);
insert into Questions (libelle, type, fichier_image, id_theme) values ('Que peut-on faire en php ?', 'multiple', null, 2);

insert into Reponses (libelle, correct, id_question) values ('Pour des traitements de requetes', 1, 1);
insert into Reponses (libelle, correct, id_question) values ('Pour manger des cacahuètes', 0, 1);
insert into Reponses (libelle, correct, id_question) values ('Pour attraper un éléphant', 0, 1);
insert into Reponses (libelle, correct, id_question) values ('Pour faire chier Max', 0, 1);
insert into Reponses (libelle, correct, id_question) values ('A faire du Html dynamique', 1, 2);
insert into Reponses (libelle, correct, id_question) values ('A insérer du code java dans une page Html', 1, 2);
insert into Reponses (libelle, correct, id_question) values ('A faire la cuisine', 0, 2);
insert into Reponses (libelle, correct, id_question) values ('Pour être on fire sur le dancefloor', 0, 2);
insert into Reponses (libelle, correct, id_question) values ('<h1>', 1, 3);
insert into Reponses (libelle, correct, id_question) values ('<form>', 1, 3);
insert into Reponses (libelle, correct, id_question) values ('<b26>', 0, 3);
insert into Reponses (libelle, correct, id_question) values ('<input>', 1, 3);
insert into Reponses (libelle, correct, id_question) values ('Entreprise Edition', 1, 4);
insert into Reponses (libelle, correct, id_question) values ('Eté Hiver',0, 4);
insert into Reponses (libelle, correct, id_question) values ('Euh Excsuez-moi',0, 4);
insert into Reponses (libelle, correct, id_question) values ('Hey salut !',0, 4);
insert into Reponses (libelle, correct, id_question) values ('Symfony', 1, 5);
insert into Reponses (libelle, correct, id_question) values ('Mozart', 0, 5);
insert into Reponses (libelle, correct, id_question) values ('Beethoven', 0, 5);
insert into Reponses (libelle, correct, id_question) values ('De Bussy', 0, 5);
insert into Reponses (libelle, correct, id_question) values ('$', 1, 6);
insert into Reponses (libelle, correct, id_question) values ('€', 0, 6);
insert into Reponses (libelle, correct, id_question) values ('LOL', 0, 6);
insert into Reponses (libelle, correct, id_question) values ('Choisis-moi', 0, 6);
insert into Reponses (libelle, correct, id_question) values ('int', 1, 7);
insert into Reponses (libelle, correct, id_question) values ('string', 1, 7);
insert into Reponses (libelle, correct, id_question) values ('boolean', 1, 7);
insert into Reponses (libelle, correct, id_question) values ('float', 1, 7);
insert into Reponses (libelle, correct, id_question) values ('du web', 1, 8);
insert into Reponses (libelle, correct, id_question) values ('du miel', 0, 8);
insert into Reponses (libelle, correct, id_question) values ('du  développement web', 1, 8);
insert into Reponses (libelle, correct, id_question) values ('des pages html dynamiques', 1, 8);

insert into Qcms (nom, niveau) values ('ECF-Développement web', 'DL');
insert into Qcms (nom, niveau) values ('ECF-Développement web avancé', 'DL');
insert into Qcms (nom, niveau) values ('ECF-SQL', 'CDI');

insert into Sections (id_qcm, id_theme, nom,  nb_questions) values (1, 1,'Java EE', 4);
insert into Sections (id_qcm, id_theme, nom,  nb_questions) values (1, 2,'Php', 4);
insert into Sections (id_qcm, id_theme, nom,  nb_questions) values (2, 1,'Java EE', 2);
insert into Sections (id_qcm, id_theme, nom,  nb_questions) values (2, 2,'Php', 3);

insert into Sessions (date_inscription, date_prevue, temps_limite,id_user, id_qcm) values (CONVERT(datetime, '16-03-2018 15:00:00', 103), CONVERT(datetime, '26-03-2018 9:00:00', 103), 120, 1,1);
insert into Sessions (date_inscription, date_prevue, temps_limite,id_user, id_qcm) values (CONVERT(datetime, '16-03-2018 15:00:00', 103), CONVERT(datetime, '26-03-2018 9:00:00', 103), 120, 2,2);

insert into Epreuves (date_passage, temps_restant, id_session) values (CONVERT(datetime, '26-03-2018 9:00:00', 103), 60, 1);
insert into Epreuves (date_passage, temps_restant, id_session) values (CONVERT(datetime, '26-03-2018 9:00:00', 103), 20, 2);


