#!/usr/bin/perl
while (<DATA>) {
  s/^ +|[`,]//g;  # 將前面的空白，以及`和,全部刪除。
  s/ /\t/;       # 中間的空白用tab取代
  print $_;     # print出來的結果進行copy
}
 
 __DATA__
     `PK_NO` INTEGER,
     `NAME` VARCHAR(20),
     `EMAIL` VARCHAR(50),
     `COMMENT` LONGBLOB,
     `COMMENT_DATE` DATETIME,
     `SEND_FLAG` INTEGER,
     `PROCESS_FLAG` INTEGER,
     `FAQ_FLAG` INTEGER,
     `PROCESS_ID` VARCHAR(20),
     `PROCESS_DATA` LONGBLOB,
     `MODIFY_DATE` DATETIME
