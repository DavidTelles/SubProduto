insert into equipes (nome, codigo) values
("MacLaren", "Codigo1"),
("Ferrari", "Codigo2"),
("Sauber", "Codigo3"),
("Audi", "Codigo4"),
("Mercedes", "Codigo5");

insert into participantes (nome) values
("David"),
("Enzo"),
("Biel"),
("Garcia"),
("Luis");

insert into equipes_participantes (id_participante, id_equipe) values 
(1, 1),
(2, 2),
(3, 5),
(4, 3),
(5, 4);

insert into pistas (nome, id_equipe) values 
("S do Senna", 1),
("P do Prost", 2),
("H do Hamiltom", 2),
("L de Lecrec",  1),
("V de Vestappem", 5);

insert into corridas (nome) values
("corrida 1"),
("Corrida 2"),
("Corrida 3"),
("Corrida 4"),
("Corrida 5");

insert into dados_corridas (id_corrida, id_equipe, tempo_volta) values
(1, 1, "00:01:36"),
(1, 1, "00:01:33"),
(1, 1, "00:01:40"),
(1, 1, "00:01:52"),
(1, 1, "00:02:08");

SELECT participantes.nome, equipes.nome
FROM equipes_participantes
JOIN participantes
	ON participantes.idparticipante = equipes_participantes.id_participante
JOIN equipes
	ON equipes.idequipe = equipes_participantes.id_participante;
  
DROP FUNCTION IF EXISTS total_de_voltas;

DELIMITER //

CREATE FUNCTION total_de_voltas(
	_id_equipe INT,
    _id_corrida INT
)
RETURNS INT
READS SQL DATA 
BEGIN
	DECLARE total INT;
    
    SELECT COUNT(id)
    INTO total
    FROM dados_corridas
    WHERE id_corrida = _id_corrida
      AND id_equipe = _id_equipe;
    
    RETURN total;
END
// DELIMITER ;

-- CRIAR FUNCTION PARA CALCULAR O TEMPO MÉDIO POR VOLTA

DROP FUNCTION IF EXISTS calcular_media;

DELIMITER //

CREATE FUNCTION calcular_media(
	_id_equipe INT,
    _id_corrida INT
)
RETURNS TIME
READS SQL DATA 
BEGIN
	DECLARE media INT;
    
    SELECT AVG(tempo_volta)
    INTO media
    FROM dados_corridas
    WHERE id_corrida = _id_corrida
      AND id_equipe = _id_equipe;
    
    RETURN media;
END
// DELIMITER ;

DROP FUNCTION IF EXISTS melhor_volta;

 DELIMITER //
CREATE FUNCTION melhor_volta(
	_id_equipe INT,
    _id_corrida INT
)
RETURNS TIME
READS SQL DATA
BEGIN
	DECLARE best TIME;
    
    SELECT MIN(tempo_volta)
	INTO best
    FROM dados_corridas
    WHERE id_corrida = _id_corrida
      AND id_equipe = _id_equipe;
      
      RETURN best;
END
// DELIMITER ;

-- CRIAR FUNCTION PARA RETORNAR O TEMPO DA ULTIMA VOLTA (CRIAR UMA COLUNA "created" COM VALOR DEFAULT current_timestamp)
ALTER TABLE dados_corridas
ADD COLUMN created TIMESTAMP DEFAULT CURRENT_TIMESTAMP;

DROP FUNCTION IF EXISTS ultima_volta;

DELIMITER //

CREATE FUNCTION ultima_volta(
    _id_equipe INT, 
    _id_corrida INT
)
RETURNS TIME
DETERMINISTIC
BEGIN
    DECLARE tempo TIME;

    SELECT tempo_volta
    INTO tempo
    FROM dados_corridas
    WHERE id_equipe = _id_equipe
      AND id_corrida = _id_corrida
    ORDER BY id DESC
    LIMIT 1;

    RETURN tempo;
END 

// DELIMITER ;

SELECT * from dados_corridas; 

SELECT ultima_volta(1, 1); 

-- CRIAR FUNCTION PARA CALCULAR A VELOCIDADE MEDIA (ADICIONAR A COLUNA distancia NA TABELA pistas)

ALTER TABLE pistas
ADD COLUMN distancia_metros DECIMAL NOT NULL;

UPDATE pistas
SET distancia_metros = 4750
WHERE id = 1;
SELECT * FROM pistas;

DROP FUNCTION IF EXISTS velocidade_media;

DELIMITER //
DELIMITER //

CREATE FUNCTION velocidade_media(
    _id_corrida INT,
    _id_equipe INT,
    _distancia_metros DECIMAL(10,2),
    _tempo_volta TIME
)
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_media DECIMAL(10,2);
    
        SELECT tempo_volta
		INTO v_media
		FROM dados_corridas
		WHERE id_equipe = _id_equipe
		AND id_corrida = _id_corrida;
        
	SET v_media = _distancia_metros / TIME_TO_SEC(_tempo_volta);

    RETURN v_media;
END
//

DELIMITER ;

SELECT velocidade_media(1, 1, 4750, "00:01:30");