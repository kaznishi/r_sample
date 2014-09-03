# 学生テーブル読み込み
students <- read.csv("sampledata_student.csv", header = T, stringsAsFactors = F)

# 試験成績テーブル読み込み
kokugo <- read.csv("sampledata_KOKUGO.csv", header = T, stringsAsFactors = F)
suugaku <- read.csv("sampledata_SUUGAKU.csv", header = T, stringsAsFactors = F)
shakai <- read.csv("sampledata_SHAKAI.csv", header = T, stringsAsFactors = F)
rika <- read.csv("sampledata_RIKA.csv", header = T, stringsAsFactors = F)
eigo <- read.csv("sampledata_EIGO.csv", header = T, stringsAsFactors = F)
ongaku <- read.csv("sampledata_ONGAKU.csv", header = T, stringsAsFactors = F)
bijutsu <- read.csv("sampledata_BIJUTSU.csv", header = T, stringsAsFactors = F)
hokentaiiku <- read.csv("sampledata_HOKENTAIIKU.csv", header = T, stringsAsFactors = F)
gijutsukatei <- read.csv("sampledata_GIJUTSUKATEI.csv", header = T, stringsAsFactors = F)

# 試験成績をひたすら学生テーブルと結合していく
students_scores <- merge(students, kokugo[,c("student_id", "KOKUGO")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, suugaku[,c("student_id", "SUUGAKU")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, shakai[,c("student_id", "SHAKAI")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, rika[,c("student_id", "RIKA")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, eigo[,c("student_id", "EIGO")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, ongaku[,c("student_id", "ONGAKU")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, bijutsu[,c("student_id", "BIJUTSU")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, hokentaiiku[,c("student_id", "HOKENTAIIKU")], by=c("student_id"), all.x=T)
students_scores <- merge(students_scores, gijutsukatei[,c("student_id", "GIJUTSUKATEI")], by=c("student_id"), all.x=T)

students_scores

# 試験成績のカラムのみ抽出
score <- students_scores[,6:14]

score

# k-meansクラスタリング処理
cluster_count <- 5
km <- kmeans(score, cluster_count, iter.max = 200)
km

km$cluster
km$centers
write.table(km$centers, file = "clustered_means.csv", sep = ",", row.names=F)

# クラスタ番号と学生データを対応付け
clustered_student <- data.frame(students_scores[,1:3],km$cluster)
names(clustered_student) <- c("student_id", "name", "class", "cluster_no")
clustered_student_score <- data.frame(clustered_student, score)

write.table(clustered_student_score, file = "clustered_student_score.csv", sep = ",", row.names=F)

# クラスタ毎に試験成績の平均を計算。km$centersと一致。
library(dplyr)
cluster_mean <- clustered_student_score %>%
    group_by(cluster_no) %>%
    summarise(
        KOKUGO = mean(KOKUGO),
        SUGAKU = mean(SUUGAKU),
        SHAKAI = mean(SHAKAI),
        RIKA = mean(RIKA),
        EIGO = mean(EIGO),
        ONGAKU = mean(ONGAKU),
        BIJUTSU = mean(BIJUTSU),
        HOKENTAIIKU = mean(HOKENTAIIKU),
        GIJUTSUKATEI = mean(GIJUTSUKATEI)
    ) %>%
    as.data.frame

cluster_mean


