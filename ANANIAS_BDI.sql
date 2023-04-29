-- Ananias Carvalho, Nicole Muniz, Joao Lucas, Lucas Daniel, Gustavo Monteiro

CREATE DATABASE  CondominioComplexo;
USE CondominioComplexo;

CREATE TABLE Endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    linha1 VARCHAR(255) NOT NULL,
    linha2 VARCHAR(255),
    numero INT NOT NULL,
    bairro VARCHAR(255) NOT NULL,
    cidade VARCHAR(255) NOT NULL,
    uf CHAR(2) NOT NULL
);

CREATE TABLE Condominio (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    endereco_id INT,
    qutcasas INT NOT NULL,
    telefonefixocondominio CHAR(10),
    idRamais INT,
    dataCriacao DATE NOT NULL,
    FOREIGN KEY (endereco_id) REFERENCES Endereco(id)
);

CREATE TABLE Casas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    condominio_id INT,
    endereco_id INT,
    qutquartos INT NOT NULL,
    nbanheiros INT NOT NULL,
    areatotal DECIMAL(10, 2) NOT NULL,
    observacao VARCHAR(255),
    FOREIGN KEY (condominio_id) REFERENCES Condominio(id),
    FOREIGN KEY (endereco_id) REFERENCES Endereco(id)
);

CREATE TABLE Moradores (
    id INT AUTO_INCREMENT PRIMARY KEY,
    condominio_id INT,
    casa_id INT,
    nomecompleto VARCHAR(255) NOT NULL,
    tel1 CHAR(10),
    tel2 CHAR(10),
    email VARCHAR(255) UNIQUE NOT NULL,
    tipoveiculo VARCHAR(255),
    cpf varchar(14) UNIQUE NOT NULL,
    observacao VARCHAR(255),
    FOREIGN KEY (condominio_id) REFERENCES Condominio(id),
    FOREIGN KEY (casa_id) REFERENCES Casas(id)
);

CREATE TABLE Funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cargo ENUM('síndico', 'administrativo', 'segurança','limpeza','manutenção') NOT NULL,
    dataAdmissao DATE NOT NULL,
    dataDemissao DATE,
    observacao VARCHAR(255)
);

CREATE TABLE Ramais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    condominio_id INT,
    idramal INT,
    nramal INT NOT NULL,
    descricao VARCHAR(255),
    FOREIGN KEY (condominio_id) REFERENCES Condominio(id)
);

CREATE TABLE Visitantes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    cpf CHAR(11) UNIQUE
);

CREATE TABLE Visitas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    condominio_id INT,
    casa_id INT,
    visitante_id INT,
    entrada DATETIME NOT NULL,
    saida DATETIME,
    observacao VARCHAR(255),
    FOREIGN KEY (condominio_id) REFERENCES Condominio(id),
    FOREIGN KEY (casa_id) REFERENCES Casas(id),
    FOREIGN KEY (visitante_id) REFERENCES Visitantes(id)
);

CREATE TABLE ChamadaServico (
    id INT AUTO_INCREMENT PRIMARY KEY,
    condominio_id INT,
    morador_id INT,
    funcionario_id INT,
    tiposervico VARCHAR(255) NOT NULL,
    descricao TEXT NOT NULL,
    status ENUM('pendente', 'em_andamento', 'concluido') NOT NULL DEFAULT 'pendente',
    observacao VARCHAR(255),
    FOREIGN KEY (condominio_id) REFERENCES Condominio(id),
    FOREIGN KEY (morador_id) REFERENCES Moradores(id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(id)
);

CREATE TABLE CondraMais (
    id INT AUTO_INCREMENT PRIMARY KEY,
    condominio_id INT,
    idramais INT,
    FOREIGN KEY (condominio_id) REFERENCES Condominio(id),
    FOREIGN KEY (idramais) REFERENCES Ramais(id)
);
USE CondominioComplexo;
DROP TABLE Seguranca;
CREATE TABLE Seguranca (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    condominio_id int,
    funcionario_id int,
    cpf CHAR(11) UNIQUE NOT NULL,
    cargo VARCHAR(255) NOT NULL,
    dataAdmissao DATE NOT NULL,
    dataDemissao DATE,
    infoadc TEXT,
    Foreign key(condominio_id) references Condominio(id),
    foreign key(funcionario_id) REFERENCES Funcionarios(id)
);

INSERT INTO Endereco (linha1, numero, bairro, cidade, uf)
VALUES ('Rua das Orquídeas', 135, 'Jardim das Rosas', 'Palmas', 'TO'),
       ('Avenida das Bromélias', 468, 'Jardim das Rosas', 'Pindorama do Tocantins', 'TO'),
       ('Rua das Magnólias', 321, 'Jardim das Tulipas', 'São Paulo', 'SP'),
       ('Rua das Palmeiras', 654, 'Jardim das Tulipas', 'Rio De Janeiro', 'RJ'),
       ('Avenida das Acácias', 87, 'Jardim das Acácias', 'São Paulo', 'SP');

INSERT INTO Condominio (nome, endereco_id, qutcasas, dataCriacao)
VALUES ('Condomínio das Orquídeas', 1, 10, '2023-01-01'),
       ('Condomínio das Bromélias', 2, 12, '2023-01-15'),
       ('Condomínio das Magnólias', 3, 8, '2023-02-01'),
       ('Condomínio das Palmeiras', 4, 15, '2023-02-15'),
       ('Condomínio das Acácias', 5, 20, '2023-03-01');

INSERT INTO Casas (condominio_id, endereco_id, qutquartos, nbanheiros, areatotal)
VALUES (1, 1, 3, 2, 120.00),
       (1, 1, 4, 3, 150.00),
       (2, 2, 3, 2, 120.00),
       (2, 2, 4, 3, 150.00),
       (3, 3, 3, 2, 120.00);

INSERT INTO Moradores (condominio_id, casa_id, nomecompleto, tel1, email, cpf)
VALUES (1, 1, 'João da Silva', '1122334455', 'joao.silva@email.com', '111.222.333-44'),
       (1, 2, 'Maria Oliveira', '1133445566', 'maria.oliveira@email.com', '222.333.444-55'),
       (2, 3, 'Carlos Souza', '1144556677', 'carlos.souza@email.com', '333.444.555-66'),
       (2, 4, 'Luciana Moraes', '1155667788', 'luciana.moraes@email.com', '444.555.666-77'),
       (3, 5, 'Gabriela Ferreira', '1166778899', 'gabriela.ferreira@email.com', '555.666.777-88');
       
ALTER TABLE Funcionarios MODIFY COLUMN cargo VARCHAR(255);
INSERT INTO Funcionarios (nome, cargo, dataAdmissao) VALUES ('Maria Oliveira', 'síndico', '2023-01-01');
INSERT INTO Funcionarios (nome, cargo, dataAdmissao) VALUES ('Paula Santos', 'administrativo', '2023-01-15');
INSERT INTO Funcionarios (nome, cargo, dataAdmissao) VALUES ('José Carlos', 'segurança', '2023-02-01');
INSERT INTO Funcionarios (nome, cargo, dataAdmissao) VALUES ('Roberto Gomes', 'manut', '2023-02-15');
INSERT INTO Funcionarios (nome, cargo, dataAdmissao) VALUES ('Ana Clara', 'limpeza', '2023-03-01');

INSERT INTO Ramais (condominio_id, idramal, nramal, descricao) VALUES
(1, 1, '101', 'Recepção'),
(1, 2, '102', 'Administração'),
(1, 3, '103', 'Manutenção'),
(2, 1, '201', 'Recepção'),
(2, 2, '202', 'Administração');



-- Chamada de segurança pendente
INSERT INTO ChamadaSeguranca (condominio_id, casa_id, morador_id, motivochamada, dhsolicitacao, status, observacao)
VALUES (1, 1, 1, 'Alarme disparado', '2023-04-28 10:00:00', 'pendente', 'Nenhuma observação.');

-- Chamada de segurança em andamento
INSERT INTO ChamadaSeguranca (condominio_id, casa_id, morador_id, motivochamada, dhsolicitacao, status, observacao)
VALUES (2, 2, 2, 'Entrada suspeita', '2023-04-28 14:30:00', 'em_andamento', 'Suspeito pode estar armado.');

-- Chamada de segurança concluída
INSERT INTO ChamadaSeguranca (condominio_id, casa_id, morador_id, motivochamada, dhsolicitacao, status, observacao)
VALUES (1, 2, 3, 'Barulhos estranhos', '2023-04-27 22:45:00', 'concluido', 'Não foi encontrado nenhum indício de invasão.');

INSERT INTO ChamadaServico (condominio_id, morador_id, funcionario_id, tiposervico, descricao, status, observacao) VALUES 
(1, 1, 4, 'Manutenção elétrica', 'Trocar lâmpada queimada na sala de estar', 'concluido', ''),
(1, 2, 4, 'Manutenção hidráulica', 'Conserto de vazamento na pia da cozinha', 'em_andamento', 'Agendado para próxima terça-feira'),
(2, 3, 5, 'Limpeza', 'Faxina geral na casa antes da mudança', 'pendente', 'Aguardando autorização do morador'),
(2, 4, 5, 'Pintura', 'Pintura das paredes da sala de jantar', 'pendente', 'Orçamento em análise');

INSERT INTO CondraMais (condominio_id, idramais) VALUES 
(1, 1),
(2, 2),
(3, 1);
    
INSERT INTO Visitantes (nome, cpf)
VALUES ('Antônio Pereira', '12345678901'),
       ('Fernanda Souza', '23456789012'),
       ('Ricardo Almeida', '34567890123'),
       ('Amanda Lima', '45678901234'),
       ('Felipe Martins', '56789012345');
       
INSERT INTO Visitas (condominio_id, casa_id, visitante_id, entrada)
VALUES (1, 1, 1, '2023-04-01 14:00:00'),
       (1, 2, 2, '2023-04-01 15:00:00'),
       (2, 3, 3, '2023-04-01 16:00:00'),
       (2, 4, 4, '2023-04-01 17:00:00'),
       (3, 5, 5, '2023-04-01 18:00:00');
       
INSERT INTO Seguranca (nome, cpf, cargo, dataAdmissao)
VALUES ('Antônio Carlos', '98765432101', 'segurança', '2023-01-01'),
       ('Rodrigo Silva', '87654321098', 'segurança', '2023-01-15'),
       ('Priscila Almeida', '76543210987', 'segurança', '2023-02-01'),
       ('Bianca Ribeiro', '65432109876', 'segurança', '2023-02-15'),
       ('Fábio Soares', '54321098765', 'segurança', '2023-03-01');