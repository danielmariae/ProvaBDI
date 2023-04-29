-- 1. Lista de todas as casas e seus respectivos moradores.
-- Corrigindo erro gramatical em TipoVinculo:
ALTER TABLE `CondominioComplexo`.`Moradores` 
CHANGE COLUMN `tipoveiculo` `tipovinculo` VARCHAR(255) NULL DEFAULT NULL;

-- Tirando UNIQUE de Morador.email (permitindo repetição de emails no caso de crianças):
ALTER TABLE `CondominioComplexo`.`Moradores` 
ADD UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC) VISIBLE,
DROP INDEX `cpf` ,
DROP INDEX `email`;
-- Insert feito para colocar mais de 1 morador na mesma casa.
INSERT INTO Moradores VALUES (6, 1, 1, 'Joana Dark', 1199991515, null, 'joanadark@gmail.com', 'inquilino', '000.000.000-00', null);
INSERT INTO Moradores VALUES (7, 1, 1, 'Joao Dark', 1199991515, null, 'joaodark@gmail.com', 'proprietario', '111.111.121-00', null);
SELECT Moradores.condominio_id, Moradores.casa_id, Casas.endereco_id, Casas.qutquartos, Casas.nbanheiros, Casas.areatotal, Casas.observacao as obscasas, Moradores.nomecompleto, Moradores.tel1, Moradores.tel2, Moradores.email, Moradores.tipovinculo, Moradores.cpf, Moradores.observacao as obsmoradores from Casas, Moradores where Casas.id = Moradores.casa_id && Moradores.condominio_id = Casas.condominio_id ORDER BY casa_id;

-- 2. Lista de todos os visitantes que visitaram um determinado condomínio em uma data específica.
-- Supondo que seja o condomínio 1 em 01/04/2023:

SELECT Visitantes.* from Visitantes, Visitas where Visitas.condominio_id = 1 AND Visitantes.id = Visitas.visitante_id AND YEAR(Visitas.entrada) = 2023 AND MONTH(Visitas.entrada) = 04 AND DAY(Visitas.entrada) = 01;

-- 3. Lista de todas as chamadas de segurança que estão em andamento.
-- Insert feito para colocar mais de 1 chamado em andamento.
INSERT INTO ChamadaSeguranca VALUES (4, 1, 1, 1, 'Movimentação estranha no interior', '2023-04-28 15:10:10', 'em_andamento', 'Estamos de olho nas câmeras de segurança');
SELECT * from ChamadaSeguranca WHERE status = 'em_andamento';

-- 4. Lista de todas as chamadas de serviços que foram concluídas em um determinado período de tempo.
-- Corrigindo a falta de início e fim da chamada em ChamadaServico (datetime):
ALTER TABLE `CondominioComplexo`.`ChamadaServico` 
ADD COLUMN `inicio_chamado` DATETIME NULL AFTER `observacao`,
ADD COLUMN `fim_chamado` DATETIME NULL AFTER `inicio_chamado`;
-- Atualizando e adicionando início e fim do chamado.
UPDATE `CondominioComplexo`.`ChamadaServico` SET `inicio_chamado` = '2023-04-28 10:00:00', `fim_chamado` = '2023-04-28 18:00:00' WHERE (`id` = '1');
-- SELECIONANDO TODOS OS CHAMADOS CONCLUIDOS EM 28-04-2023.
SELECT * from ChamadaServico WHERE status = 'concluido' AND YEAR(ChamadaServico.fim_chamado) = 2023 AND MONTH(ChamadaServico.fim_chamado) = 04 AND DAY(ChamadaServico.fim_chamado) = 28;

-- 5. Lista de todas as casas que possuem mais de 3 quartos.
SELECT * From Casas where qutquartos > 3;

-- 6. Lista de todas as chamadas de segurança atendidas por um determinado segurança. 
-- Adicionando a chave estrangeira `segurança_id`, faltante na tabela.
ALTER TABLE `CondominioComplexo`.`ChamadaSeguranca` 
ADD COLUMN `seguranca_id` INT NULL AFTER `morador_id`;
ALTER TABLE `CondominioComplexo`.`ChamadaSeguranca` 
ADD INDEX `seguranca_id_idx` (`seguranca_id` ASC) VISIBLE;
;
ALTER TABLE `CondominioComplexo`.`ChamadaSeguranca` 
ADD CONSTRAINT `seguranca_id`
  FOREIGN KEY (`seguranca_id`)
  REFERENCES `CondominioComplexo`.`Seguranca` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
-- Atualizando os dados para adicionar os seguranças nas consultas.  
UPDATE `CondominioComplexo`.`ChamadaSeguranca` SET `seguranca_id` = '1' WHERE (`id` = '1');
UPDATE `CondominioComplexo`.`ChamadaSeguranca` SET `seguranca_id` = '1' WHERE (`id` = '2');
UPDATE `CondominioComplexo`.`ChamadaSeguranca` SET `seguranca_id` = '2' WHERE (`id` = '3');
UPDATE `CondominioComplexo`.`ChamadaSeguranca` SET `seguranca_id` = '3' WHERE (`id` = '4');
-- Considerando o segurança 1 como o segurança procurado:
SELECT * from ChamadaSeguranca where seguranca_id = 1;

-- 7. Lista de todos os moradores que são proprietários de suas casas.
SELECT * from Moradores where tipovinculo = 'proprietario';

-- 8. Lista de todas as casas que foram construídas após uma determinada data.
-- Criando e atualizando a data de construção das casas no Modelo:
ALTER TABLE `CondominioComplexo`.`Casas` 
ADD COLUMN `dataconstrucao` DATE NULL AFTER `areatotal`;
UPDATE `CondominioComplexo`.`Casas` SET `dataconstrucao` = '2018-05-01' WHERE (`id` = '1');
UPDATE `CondominioComplexo`.`Casas` SET `dataconstrucao` = '2019-01-20' WHERE (`id` = '2');
UPDATE `CondominioComplexo`.`Casas` SET `dataconstrucao` = '2019-01-21' WHERE (`id` = '3');
UPDATE `CondominioComplexo`.`Casas` SET `dataconstrucao` = '2020-08-07' WHERE (`id` = '4');
UPDATE `CondominioComplexo`.`Casas` SET `dataconstrucao` = '2021-03-04' WHERE (`id` = '5');
-- Todas as casas criadas no BD em 20/01/2019 ou depois.
SELECT * from Casas where dataconstrucao >= '2019-01-20';
 
-- 9. Lista de todas as chamadas de segurança realizadas em um determinado condomínio.
-- Listando todas as chamadas de segurança no condomínio 01.
SELECT * from ChamadaSeguranca where condominio_id = 1;


-- 10. Lista de todos os visitantes que visitaram uma determinada casa em um determinado período de tempo.
-- Criando mais uma visita na casa 1 do condomínio 1.
INSERT INTO `CondominioComplexo`.`Visitas` (`id`, `condominio_id`, `casa_id`, `visitante_id`, `entrada`) VALUES ('6', '1', '1', '2', '2023-04-01 14:10:00');
-- Todos os visitantes da casa 01 do condomínio 01 em 01/04/2023.
Select * FROM Visitas WHERE YEAR(Visitas.entrada) = 2023 AND MONTH(Visitas.entrada) = 04 AND DAY(Visitas.entrada) = 01 AND casa_id = 1 AND condominio_id = 1;

-- 11. Lista de todas as chamadas de serviços atendidas por um determinado funcionário administrativo.
-- Chamadas atendidas pelo funcionário 4:
SELECT * FROM ChamadaServico where funcionario_id = 4;

-- 12. Lista de todos os moradores que possuem um determinado tipo de vínculo com suas casas.
SELECT * FROM Moradores;
-- Update para mostrar mais de um inquilino.
UPDATE `CondominioComplexo`.`Moradores` SET `tipovinculo` = 'inquilino' WHERE (`id` = '5');
-- Mostrando todos os inquilinos do condomínio:
SELECT * FROM Moradores WHERE tipovinculo = 'inquilino';

-- 13. Lista de todas as chamadas de segurança realizadas em um determinado período de tempo.
-- Todas as chamadas de segurança realizadas em 28-04-2023.
SELECT * from ChamadaSeguranca WHERE YEAR(ChamadaSeguranca.dhsolicitacao) = 2023 AND MONTH(ChamadaSeguranca.dhsolicitacao) = 04 AND DAY(ChamadaSeguranca.dhsolicitacao) = 28;

-- 14. Lista de todas as casas que possuem mais de 2 banheiros.
SELECT * FROM Casas where nbanheiros > 2;

-- 15. Lista de todas as chamadas de serviços realizadas em um determinado condomínio.
-- Consideramos o condomínio 2 para a consulta.
SELECT * FROM ChamadaServico where condominio_id = 2;

-- 16. Lista de todos os funcionários administrativos que foram demitidos em um determinado período de tempo.
-- Adicionando data de demissão dos funcionários 02 e 03.
UPDATE `CondominioComplexo`.`Funcionarios` SET `dataDemissao` = '2023-03-01' WHERE (`id` = '2');
UPDATE `CondominioComplexo`.`Funcionarios` SET `dataDemissao` = '2023-03-12' WHERE (`id` = '3');
-- Todos os funcionários demitidos em MAR-2023:
SELECT * FROM Funcionarios where dataDemissao >= '2023-03-01' and dataDemissao <= '2023-03-31';

-- 17. Lista de todas as casas alugadas.
-- Adicionando tipomoradia ao BD:
ALTER TABLE `CondominioComplexo`.`Casas` 
ADD COLUMN `tipomoradia` VARCHAR(45) NULL AFTER `endereco_id`;
-- Update com tipos de moradia adicionados:
UPDATE `CondominioComplexo`.`Casas` SET `tipomoradia` = 'aluguel' WHERE (`id` = '3');
UPDATE `CondominioComplexo`.`Casas` SET `tipomoradia` = 'casa_propria' WHERE (`id` = '2');
UPDATE `CondominioComplexo`.`Casas` SET `tipomoradia` = 'casa_propria' WHERE (`id` = '1');
UPDATE `CondominioComplexo`.`Casas` SET `tipomoradia` = 'aluguel' WHERE (`id` = '4');
-- SELECT FEITO:
SELECT * FROM Casas where Casas.tipomoradia = 'aluguel';

-- 18. Lista de todas as chamadas de segurança realizadas em uma determinada casa.
-- CHAMADAS REALIZADAS NA CASA 1 DO CONDOMÍNIO 01.
SELECT * from ChamadaSeguranca WHERE condominio_id = 1 and casa_id = 1;

-- 19. Lista de todos os seguranças que estão atualmente empregados pela empresa.
-- Todos os seguranças que não foram demitidos pela empresa.
SELECT * from Seguranca WHERE dataDemissao is null;

-- 20. Lista de todas as chamadas de serviços que ainda estão abertas.
SELECT * FROM ChamadaServico where status != 'concluido';

-- 21. Lista de todas as casas que possuem uma determinada quantidade de quartos e seus respectivos moradores.
-- Casas com 3 quartos e moradores:
SELECT Moradores.condominio_id, Moradores.casa_id, Casas.endereco_id, Casas.qutquartos, Casas.nbanheiros, Casas.areatotal, Casas.observacao as obscasas, Moradores.nomecompleto, Moradores.tel1, Moradores.tel2, Moradores.email, Moradores.tipovinculo, Moradores.cpf, Moradores.observacao as obsmoradores from Casas, Moradores where Casas.id = Moradores.casa_id && Moradores.condominio_id = Casas.condominio_id and Casas.qutquartos = 3 ORDER BY casa_id;

-- 22. Lista de todas as chamadas de segurança realizadas em uma determinada data.
-- Todas as chamadas de segurança feitas em 27/04/2023.
SELECT * FROM ChamadaSeguranca WHERE YEAR(ChamadaSeguranca.dhsolicitacao) = 2023 AND MONTH(ChamadaSeguranca.dhsolicitacao) = 04 AND DAY(ChamadaSeguranca.dhsolicitacao) = 27;

-- 23. Lista de todos os moradores que residem em um determinado condomínio.
-- Todos os moradores do condomínio 2.
SELECT * FROM Moradores where condominio_id = 2;

-- 24. Lista de todas as chamadas de serviços que foram realizadas por um determinado morador.
-- Inserindo chamada de servico do morador 1:
INSERT INTO `CondominioComplexo`.`ChamadaServico` (`id`, `condominio_id`, `morador_id`, `funcionario_id`, `tiposervico`, `descricao`, `status`, `observacao`, `inicio_chamado`, `fim_chamado`) VALUES ('5', '1', '1', '4', 'Manutenção hidráulica', 'Corrigir vazamento em pia da suíte.', 'concluido', '', '2023-04-28 12:00:00', '2023-04-28 14:00:00');
SELECT * FROM ChamadaServico WHERE morador_id = 1;

-- 25. Lista de todas as casas que possuem uma determinada área total e seus respectivos moradores.
-- Casas com 150metros quadrados e moradores.
SELECT Moradores.condominio_id, Moradores.casa_id, Casas.endereco_id, Casas.qutquartos, Casas.nbanheiros, Casas.areatotal, Casas.observacao as obscasas, Moradores.nomecompleto, Moradores.tel1, Moradores.tel2, Moradores.email, Moradores.tipovinculo, Moradores.cpf, Moradores.observacao as obsmoradores from Casas, Moradores where Casas.id = Moradores.casa_id && Moradores.condominio_id = Casas.condominio_id and Casas.areatotal = 150.00 ORDER BY casa_id;
