CREATE DATABASE Oficina_OS;
USE Oficina_OS;

-- Tabela de Clientes
CREATE TABLE Cliente (
    idCliente INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(60) NOT NULL,
    telefone CHAR(11),
    endereco VARCHAR(150),
    tipo_cliente ENUM('Pessoa Física', 'Pessoa Jurídica') NOT NULL,
    PRIMARY KEY (idCliente),
    CONSTRAINT chk_tipo_cliente CHECK (tipo_cliente IN ('Pessoa Física', 'Pessoa Jurídica'))
);

-- Tabela de Veículos
CREATE TABLE Veiculo (
    idVeiculo INT NOT NULL AUTO_INCREMENT,
    cliente_id INT NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    ano INT,
    placa VARCHAR(10),
    PRIMARY KEY (idVeiculo),
    UNIQUE KEY uk_placa (placa),
    CONSTRAINT fk_veiculo_cliente FOREIGN KEY (cliente_id) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);

-- Tabela de Mecânicos
CREATE TABLE Mecanico (
    idMecanico INT NOT NULL AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    endereco VARCHAR(150),
    especialidade VARCHAR(30),
    PRIMARY KEY (idMecanico)
);

-- Tabela de Equipes
CREATE TABLE Equipe (
    idEquipe INT NOT NULL AUTO_INCREMENT,
    nome_equipe VARCHAR(45) NOT NULL,
    PRIMARY KEY (idEquipe)
);

-- Tabela Equipe_Macanico
CREATE TABLE Equipe_Mecanico (
    idEquipe INT NOT NULL,
    idMecanico INT NOT NULL,
    PRIMARY KEY (idEquipe, idMecanico),
    CONSTRAINT fk_equipe_mecanico_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe) ON DELETE CASCADE,
    CONSTRAINT fk_equipe_mecanico_mecanico FOREIGN KEY (idMecanico) REFERENCES Mecanico(idMecanico) ON DELETE CASCADE
);

-- Tabela de Ordens de Serviço (OS) 
CREATE TABLE Ordem_Servico (
    id_os INT NOT NULL AUTO_INCREMENT,
    idVeiculo INT,
    idEquipe INT,
    data_emissao DATE NOT NULL,
    valor_total DECIMAL(10, 2),
    status ENUM('Aberta', 'Aguardando Aprovação', 'Em Execução', 'Concluída', 'Cancelada') NOT NULL,
    data_conclusao DATE,
    PRIMARY KEY (id_os),
    CONSTRAINT fk_os_veiculo FOREIGN KEY (idVeiculo) REFERENCES Veiculo(idVeiculo) ON DELETE SET NULL,
    CONSTRAINT fk_os_equipe FOREIGN KEY (idEquipe) REFERENCES Equipe(idEquipe) ON DELETE SET NULL
);

-- Tabela de Tipos de Serviço
CREATE TABLE Tipo_Servico (
    idTipoServico INT NOT NULL AUTO_INCREMENT,
    tipo ENUM('Conserto', 'Revisão') NOT NULL,
    PRIMARY KEY (idTipoServico),
    CONSTRAINT chk_tipo_servico CHECK (tipo IN ('Conserto', 'Revisão'))
);

-- Tabela de Serviço
CREATE TABLE Servico (
    idServico INT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(200) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    idTipoServico INT NOT NULL,
    PRIMARY KEY (idServico),
    CONSTRAINT fk_servico_tipo FOREIGN KEY (idTipoServico) REFERENCES Tipo_Servico(idTipoServico) ON DELETE RESTRICT
);

-- Tabela Serviço Realizado
CREATE TABLE Servico_Realizado (
    id_os INT,
    idServico INT,
    quantidade INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_os, idServico),
    CONSTRAINT fk_sr_os FOREIGN KEY (id_os) REFERENCES Ordem_Servico(id_os) ON DELETE CASCADE,
    CONSTRAINT fk_sr_servico FOREIGN KEY (idServico) REFERENCES Servico(idServico) ON DELETE CASCADE
);

-- Tabela Peças
CREATE TABLE Peca (
    idPeca INT NOT NULL AUTO_INCREMENT,
    descricao VARCHAR(150) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    estoque INT NOT NULL,
    PRIMARY KEY (idPeca)
);

-- Tabela peça Utilizada
CREATE TABLE Peca_Utilizada (
    id_os INT,
    idPeca INT,
    quantidade INT NOT NULL,
    valor DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (id_os, idPeca),
    CONSTRAINT fk_pu_os FOREIGN KEY (id_os) REFERENCES Ordem_Servico(id_os) ON DELETE CASCADE,
    CONSTRAINT fk_pu_peca FOREIGN KEY (idPeca) REFERENCES Peca(idPeca) ON DELETE CASCADE
);

-- Tabela Autorização
CREATE TABLE Autorizacao (
    idAutorizacao INT NOT NULL AUTO_INCREMENT,
    id_os INT,
    idCliente INT,
    data_autorizacao DATE NOT NULL,
    autorizado BOOLEAN NOT NULL,
    PRIMARY KEY (idAutorizacao),
    CONSTRAINT fk_autorizacao_os FOREIGN KEY (id_os) REFERENCES Ordem_Servico(id_os) ON DELETE CASCADE,
    CONSTRAINT fk_autorizacao_cliente FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente) ON DELETE CASCADE
);


