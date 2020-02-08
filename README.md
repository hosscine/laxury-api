# Laxury API

```
source("scraping.R")

session <- get_new_session()
get_bill(session, no = 1)
```

```
$date
[1] "2020-01-27"

$invoice
# A tibble: 32 x 3
date   name                                       pay   
<chr>  <chr>                                      <chr> 
  1 191206 ＱＰ／オ－ケ－コクブンジテン               2,486 
2 191207 トウキヨウエキグランスタ                   7,656 
3 191207 トウキヨウエキグランスタ                   3,216 
4 191208 シラヌカチヨウヤクバ                       10,000
5 191208 ムロトシフルサトプレミアム                 28,000
6 191209 ＰＡＹＰＡＬ　＊ＳＴＥＡＭ　ＧＡＭＥＳ     2,310 
7 191212 トウキヨウガス・１１１６－０４７－１０１４ 9,422 
8 191213 スイカ（ケ－タイケツサイ）                 5,000 
9 191214 ＡＰＰＬＥ　ＣＯＭ　ＢＩＬＬ               1,480 
10 191214 ＱＰ／オ－ケ－コクブンジテン               8,837 
# … with 22 more rows
```