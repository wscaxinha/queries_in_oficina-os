# 🚗 Oficina-OS Database Queries
<p style="text-align: justify;">
O sistema Oficina-OS é  um conjunto de queries SQL projetadas para atender às demandas de um sistema completo de gestão de ordens de serviço em oficinas mecânicas. Este trabalho explora o uso de conceitos e cláusulas SQL, permitindo a criação de relatórios detalhados e a análise estratégica dos dados armazenados no banco. A seguir, destacamos as principais cláusulas e técnicas implementadas, que demonstram como transformar dados brutos em informações valiosas para otimização de processos e suporte à tomada de decisões.
</p>

## 1. Consulta de Clientes por Tipo 🔧
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo: </strong>Recuperar todos os clientes que são Pessoa Física.
</p>

```sql
SELECT 
    idCliente, nome, telefone, endereco, tipo_cliente
FROM 
    Cliente
WHERE 
    tipo_cliente = 'Pessoa Física';
```

## 2. Percentual de Autorizações Concedidas 🔧
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo: </strong> Calcula o percentual de autorizações concedidas em relação ao total de autorizações.
</p>

```sql
SELECT 
    ROUND((SUM(CASE WHEN a.autorizado = TRUE THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 0)
    AS percentual_autorizado FROM Autorizacao a;
```
## 3. Agrupamento com Cálculo Agregado 🔧
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo:</strong> Calcular o total de serviços realizados por tipo de serviço.
</p>

```sql
SELECT 
    ts.tipo AS tipo_servico, 
    COUNT(sr.idServico) AS Total_Servicos
FROM 
    Tipo_Servico ts
JOIN 
    Servico s ON ts.idTipoServico = s.idTipoServico
JOIN 
    Servico_Realizado sr ON s.idServico = sr.idServico
GROUP BY 
    ts.tipo
ORDER BY 
    total_servicos DESC;
```
## 4. Combinação de Agrupamento e Ordenação 🔧
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo: </strong> Exibir o total de autorizações por status (autorizado ou não autorizado), ordenadas pelo maior número.
</p>

```sql
SELECT 
    CASE 
        WHEN autorizado = TRUE THEN 'Autorizado' 
        ELSE 'Não Autorizado' 
    END AS status,
    COUNT(*) AS Total_Autorizacoes
FROM 
    Autorizacao
GROUP BY 
    autorizado
ORDER BY 
    total_autorizacoes DESC;
```
## 5. Filtrar ordens de serviço com valor total acima de R$ 500,00 🔧
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo: </strong> Identificar quais ordens de serviço têm um custo elevado.
</p>

```sql
SELECT 
    id_os, 
    SUM(valor) AS Total_Valor
FROM 
    Servico_Realizado
GROUP BY 
    id_os
HAVING 
    SUM(valor) > 500.00;
```
## 6. Listar serviços mais requisitados nas ordens de serviço 🔧
<strong style="color: #FFA500;">Objetivo: </strong> Determinar quais serviços são mais populares, ajudando na priorização de recursos e marketing.

```sql
SELECT 
    s.descricao AS Serviço,
    COUNT(sr.idServico) AS Vezes_Realizado
FROM 
    Servico_Realizado sr
JOIN 
    Servico s ON sr.idServico = s.idServico
GROUP BY 
    s.descricao
ORDER BY 
    vezes_realizado DESC;
```
## 7. Calcular o custo total de peças por serviço realizado 🔧
<strong style="color: #FFA500;">Objetivo: </strong> Determinar o custo das peças utilizadas para cada serviço realizado. Isso auxilia no controle de custos operacionais e no cálculo de margens de lucro.

```sql
SELECT 
    sr.idServico,
    s.descricao AS Serviço,
    SUM(pu.quantidade * p.preco) AS Custo_Total_Pecas
FROM 
    Servico_Realizado sr
JOIN 
    Peca_Utilizada pu ON sr.id_os = pu.id_os
JOIN 
    Peca p ON pu.idPeca = p.idPeca
JOIN 
    Servico s ON sr.idServico = s.idServico
GROUP BY 
    sr.idServico, s.descricao;
```
## 8. Listar equipes, mecânicos e as ordens de serviço associadas 🔧
<p style="text-align: justify;">
<strong style="color: #FFA500;">Objetivo: </strong>Mostrar quais mecânicos dentro de uma equipe trabalharam em ordens de serviço específicas. Isso ajuda na análise de eficiência e produtividade por equipe e mecânico
</p>

```sql
SELECT 
    e.nome_equipe,
    m.nome AS Mecânico,
    os.id_os,
    os.data_emissao
FROM 
    Equipe e
JOIN 
    Equipe_Mecanico em ON e.idEquipe = em.idEquipe
JOIN 
    Mecanico m ON em.idMecanico = m.idMecanico
JOIN 
    Ordem_Servico os ON e.idEquipe = os.idEquipe;
```
## Conclusão 🧰
<p style="text-align: justify;">
As queries implementadas no banco de dados ordem de serviço de uma oficina exemplificam o potencial da SQL em gerenciar dados complexos, conectando múltiplas tabelas com junções, aplicando funções de agregação para sumarização, e utilizando filtros condicionais para segmentar informações relevantes. Essas operações não apenas fornecem uma visão detalhada, mas também transformam dados brutos em insights estratégicos. São ferramentas fundamentais para otimizar a tomada de decisão, aprimorar a gestão operacional e potencializar a eficiência em sistemas de ordem de serviço para oficinas e outros contextos empresariais, consolidando a tecnologia como um diferencial competitivo na era da informação.
</p>



