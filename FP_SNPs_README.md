## Подготовка данных:
Сначала скачала данные
Привела талицу к более-менее похожему VCF-формату. Для этого:

1. Удалила координаты по GRCh37;
   
``` python
data_ = data.drop(['GB37_position'], axis=1)
```
   
3. Переименовала и поменяла колонки местами;

``` python
data_ = data_.rename(columns={'GB38_position': 'POS', 'chromosome': 'CHROM', 'rs#': 'ID'})
data__ = data_[['CHROM', 'POS', 'ID', 'allele1', 'allele2']]
```

4. Добавила префиксы к колонкам *CHROM*, *ID*
   -Для этого необходимо сначало было изменить тип данных:
   ``` python
   data__['CHROM'] = data__['CHROM'].astype(str)
   data__['ID'] = data__['ID'].astype(str)
   ```
``` python
data__['CHROM'] = data__['CHROM'].apply(lambda x: "chr" + x)
data__['ID'] = data__['ID'].apply(lambda x: "rs" + x)
```
5. Удалила варианты с X-хромосомой, крайние 1000 FP в файле SNPs (в файле это хромосома с номером 23),

``` python
data_no_x = data__[data__['CHROM'] != 'chr23']
```
Такая табличка у меня получилась
<img width="544" alt="Снимок экрана 2024-03-31 в 6 51 43 PM" src="https://github.com/Albinam1/docker/assets/96633706/0e259ced-d9fd-4e92-8292-a2faef711eaa">


6. Скачала получившийся файл:
``` python
data_no_x.to_csv('FP_SNPs_10k_GB38_twoAllelsFormat.tsv', sep='\t', index=False)
```
7. Заново открыла посмотрела
``` python
df= pd.read_csv('/content/FP_SNPs_10k_GB38_twoAllelsFormat.tsv', sep='\t')
```

Далее т.к. у меня памяти не так много, чтобы скачать референсный геном я решила референсы найти другим способом-
Я решила через rs на сайте https://www.ncbi.nlm.nih.gov/snp/ информацию добавить в таблицу и с помощью этого можно восстановить информацию 
о референсном значении

Представлен код для первой хромосомы:

``` python
record_chr1 = []
for rs in rs_table_chr1:
  url = f"https://www.ncbi.nlm.nih.gov/snp/{rs}/"
  #print(url)
  response = requests.get(url)
  soup = BeautifulSoup(response.text, "html.parser")
  for rows in soup.find("dt"):
    position_element = soup.find('dt', string='Position').find_next('span').string.strip()
    #print(position_element)
    allele_element = soup.find('dt', string='Alleles').find_next('dd').string.strip()
    #print(allele_element)

  record_chr1.append([position_element, allele_element])
```

8. Обработала все хромосомы выписывая референс

<img width="436" alt="Снимок экрана 2024-03-31 в 7 40 43 PM" src="https://github.com/Albinam1/docker/assets/96633706/07f9eab3-557b-4066-871d-8fdf0c951367">


https://colab.research.google.com/drive/1lNR0pPuZSU2QgzfIJZi6oFI2RGriVAdg?usp=sharing - скрипт для первой хромосомы

9. Объединила все датафреймы в один большой
Объединенная таблица содержала дупликаты, удалила их Итоговая таблица получилась размером: (10000, 6)
<img width="820" alt="Снимок экрана 2024-04-03 в 6 13 14 PM" src="https://github.com/Albinam1/docker/assets/96633706/ca02f37d-9a5a-4a32-a83a-431239c87ece">

Получила такую таблицу
<img width="1114" alt="Снимок экрана 2024-04-03 в 6 21 14 PM" src="https://github.com/Albinam1/docker/assets/96633706/70a344a2-48ae-44b5-808b-37a98170363d">

10. #В allele3 записываю значение из allele1 и allele2 отличное от референса
```{python}
Data_['allele3'] = Data_.apply(lambda x: x['allele1'] if x['allele1'] != x['REF'] else x['allele2'], axis=1)
```
<img width="990" alt="Снимок экрана 2024-04-03 в 6 23 36 PM" src="https://github.com/Albinam1/docker/assets/96633706/bbc43eb2-f6af-4b8d-b33b-a679faaa6cf6">

11. Проанализировала таблицу по значениям, у кторых allele1 и allele2 оба не совпадают с референсом - их 9ть:
<img width="855" alt="Снимок экрана 2024-04-03 в 6 24 00 PM" src="https://github.com/Albinam1/docker/assets/96633706/01f881b6-5dad-4e92-8cfc-4695f8ff3ac8">

Это потому что возможно несколько альтернативных вариантов, не один. Все они попались в данном файле
<img width="971" alt="Снимок экрана 2024-04-03 в 8 04 20 PM" src="https://github.com/Albinam1/docker/assets/96633706/3334ea88-5829-4284-bc46-86957523f93e">

Действительно, несколько альтернативных вариантов может быть 


