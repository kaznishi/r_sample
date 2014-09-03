# 変数への代入
hoge <- 1

# データの表示
hoge

# ベクトルの生成
hoge <- c('a1','b2','c3')
hoge

hoge <- c(3,5,7)
hoge

# ベクトルの足し算
hoge <- c(1,2,3)
fuga <- c(3,4,5)
result <- hoge + fuga
result

# ベクトルの掛け算
hoge <- c(1,2,3)
fuga <- c(3,4,5)
result <- hoge * fuga
result

# ベクトルすべてにxという数字をかけたい
hoge <- c(1,2,3)
result <- hoge * 3
result

# ベクトルの特定要素を抽出したい
hoge <- c('a1','b2','c3','d4','e5')
result <- hoge[2]
result

result <- hoge[2:4]
result

# データフレーム(ベクトルが複数束ねられた行列) ※Rのデータ構造では行列型とデータフレーム型が別々に定義されている。両方とも似ているが、行列型はすべてのカラムが同じデータ型(数値only,文字列only)でなければならないのに対して、データフレームはカラムごとに異なるデータ型を格納可能。普段はデータフレーム型を使うことが多いだろう。
# データフレーム生成
hoge <- data.frame(hogecolumn = c(1,2,5), fugacolumn = c('a1','b2','c3'))
hoge

# データフレームの特定列にアクセス
hoge <- data.frame(hoge1column = c(1,2,5), hoge2column = c(100,200,300), fugacolumn = c('a1','b2','c3'))
result <- hoge$hoge2column
result

result <- hoge[,2]
result

result <- hoge[,2:3]
result

result <- hoge[,c("hoge1column")]
result

result <- hoge[,c("hoge1column", "fugacolumn")]
result

# データフレームに列を追加
hoge <- data.frame(hoge1column = c(1,2,5), fugacolumn = c('a1','b2','c3'))
hoge$hoge2column <- c(100,200,300)
hoge
hoge$hoge3column <- hoge$hoge1column + hoge$hoge2column
hoge

# データフレームの特定行にアクセス
hoge <- data.frame(hoge1column = c(1,2,5), hoge2column = c(100,200,300), fugacolumn = c('a1','b2','c3'))
result <- hoge[2]
result

result <- hoge[2:3,]
result

# データフレームの特定条件にあてはまる行を抽出
hoge <- data.frame(
    hoge1column = c(1,2,5),
    hoge2column = c(100,200,300),
    fugacolumn = c('a1','b2','c3'),
    condition = c('OK','NG','OK')
)

result <- subset(hoge, hoge$condition == 'OK')
result
result <- subset(hoge, hoge$hoge2column >= 200)
result
result <- subset(hoge, hoge$condition == 'OK' & hoge$hoge2column >= 200)
result
result <- subset(hoge, hoge$hoge1column == 1 | hoge$hoge2column == 200)
result

# 文字列操作
hoge <- '2012-03-12 23:11:23'
#とりあえずよく使いそうな抽出だけ紹介
result <- substr(hoge, 1, 7)
result

hoge <- data.frame(
    access_id = c(1,2,3),
    access_datetime = c('2014-07-12 12:23:11','2014-07-12 14:20:10','2014-07-15 12:00:00')
)
hoge$access_month <- substr(hoge$access_datetime, 1,7)
hoge

# データフレームの結合(単純なつなぎ合わせ)
hoge <- data.frame(
    hoge1column = c(1,2,5),
    hoge2column = c(100,200,300)
)
fuga <- data.frame(
    fuga1column = c(10,20,50),
    fuga2column = c(1000,2000,3000)
)

result <- data.frame(hoge$hoge1column, fuga)
result


# データフレームの結合(join)
access_log <- data.frame(
    access_id = c(1,2,3,4),
    user_id = c(1,1,2,100),
    access_datetime = c('2014-07-12 12:23:11','2014-07-12 14:20:10','2014-07-15 12:00:00','2014-08-15 12:00:00')
)
users <- data.frame(
    user_id = c(1,2,3,4),
    user_name = c('John','Kevin','Ren','Robert')
)

# inner_join
result <- merge(access_log, users, by=c("user_id"))
result
# left_join
result <- merge(access_log, users, by=c("user_id"), all.x=T)
result
# right_join
result <- merge(access_log, users, by=c("user_id"), all.y=T)
result
# full_join
result <- merge(access_log, users, by=c("user_id"), all=T)
result

#2テーブルで結合に使いたいカラム名が異なる場合
access_log <- data.frame(
    access_id = c(1,2,3,4),
    user_id = c(1,1,2,100),
    access_datetime = c('2014-07-12 12:23:11','2014-07-12 14:20:10','2014-07-15 12:00:00','2014-08-15 12:00:00')
)
users <- data.frame(
    id = c(1,2,3,4),
    name = c('John','Kevin','Ren','Robert')
)
result <- merge(access_log, users, by.x="user_id",by.y="id")
result

# CSVの読み込み
csvdata <- read.csv("sampledata_student.csv", header = T, stringsAsFactors = F)
csvdata
head(csvdata, n=10) # 頭10行だけ表示

# CSVの書き込み
hoge <- data.frame(
    hoge1column = c(1,2,5),
    hoge2column = c(100,200,300),
    fugacolumn = c('a1','b2','c3'),
    condition = c('OK','NG','OK')
)
write.table(hoge, file = "outputsample.csv", sep = ",", row.names=F)

# dplyrパッケージを使ってグループ集計
#install.packages('dplyr')
library(dplyr)

csvdata <- read.csv("sampledata_student.csv", header = T, stringsAsFactors = F)
csvdata
class_mean <- csvdata %>%
    group_by(class) %>%
    summarise(
        sleeptime_h = mean(sleeptime_h),
        studytime_h = mean(studytime_h)
    ) %>%
    as.data.frame
class_mean

