# projeto-pre-processamento
Projeto de pré-processamento de dados utilizando Python e SQL, feito com base no dataset do [Audible.in disponibilizado no Kaggle](https://www.kaggle.com/datasets/snehangsude/audible-dataset).

O projeto teve como objetivo:
- Realizar o pré-processamento do dataset utilizando SQL (MySQL);
- Realizar o pré-processamento do dataset utilizando Python, em especial a biblioteca Pandas;
- Comparar a eficiência entre as duas linguagens para o pré-processamento de dados.

Concluiu-se que:
- O pré-processamento dos dados utilizando Python foi mais rápido e simples em comparação ao SQL.
- Isto se dá especialmente pelas funções da biblioteca Pandas, as quais permitem que procedimentos onerosos no SQL sejam feitos em uma ou poucas linhas utilizando Python.
- Porém, deve-se considerar o tamanho do dataset. SQL é mais eficiente para processar datasets com milhões de linhas do que Python. Portanto, é importante ponderar qual linguagem é mais apropriada para cada contexto.
