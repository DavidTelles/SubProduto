DROP DATABASE IF EXISTS pf_02;
CREATE DATABASE IF NOT EXISTS pf_02;
USE pf_02;

CREATE TABLE IF NOT EXISTS equipes (
	idequipe INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL,
    codigo VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS participantes (
	idparticipante INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS equipes_participantes (
	 id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
     id_participante INT NOT NULL,
     id_equipe INT NOT NULL,
     FOREIGN KEY (id_participante) REFERENCES participantes(idparticipante),
     FOREIGN KEY (id_equipe) REFERENCES equipes(idequipe)
);

CREATE TABLE IF NOT EXISTS pistas (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR(255),
    id_equipe INT NULL,
    FOREIGN KEY (id_equipe) REFERENCES equipes(idequipe)
);

CREATE TABLE IF NOT EXISTS corridas (
	idcorrida INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome VARCHAR (255) NOT NULL
);

CREATE TABLE IF NOT EXISTS dados_corridas (
	id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_corrida INT NOT NULL,
    id_equipe INT NOT NULL,
    tempo_volta TIME NULL,
    FOREIGN KEY (id_corrida) REFERENCES corridas(idcorrida),
    FOREIGN KEY (id_equipe) REFERENCES equipes(idequipe)
);

CREATE TABLE IF NOT EXISTS podiums (
	idpodium INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    id_corrida INT NOT NULL,
    id_equipe INT NOT NULL,
    total_voltas INT NOT NULL,
    melhor_volta INT NOT NULL,
    tempo_ultima_volta TIME NOT NULL,
    velocidade_media FLOAT NOT NULL,
    posicao INT NOT NULL,
	FOREIGN KEY (id_corrida) REFERENCES corridas(idcorrida),
    FOREIGN KEY (id_equipe) REFERENCES equipes(idequipe)
);

CREATE TABLE IF NOT EXISTS pontuacao (
	idpodium INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    nome_pista VARCHAR(255) NOT NULL,
    nome_equipe VARCHAR(255) NOT NULL,
    total_voltas INT NOT NULL,
    tempo_ultima_volta TIME NOT NULL,
    valocidade_media TIME NOT NULL,
    posicao INT NOT NULL
);