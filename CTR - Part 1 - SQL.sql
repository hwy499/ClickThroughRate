## Click Through Rate
## Wenyi Hu

set global local_infile = True; # enable loading file in client side


/***********************************************************************************************************************
1. Using MySQL (and DataGrip), create a database called ctr
***********************************************************************************************************************/

-- Drop a database
drop database if exists ctr;

-- create a database
create database ctr;

-- Select default database;
use ctr;

/***********************************************************************************************************************
2. Create table schemas, set appropriate data types, and import the raw data.
   Tables: ad_info, clicks, views, and transactions
***********************************************************************************************************************/

-- List tables in a database
show tables;

-- Drop the ad_info, clicks, views, and transactions tables if they already exist
drop table if exists ad_info, clicks, views, transactions;
drop table if exists ad_info;
/************************************************/

-- Create and load ad_info table
create table if not exists ad_info (
  row_id int not null,
  ad_id varchar(10) not null,
  ad_loc int,
  ad_label varchar(10),
  begin_time datetime,
  end_time datetime,
  pic_url varchar(100),
  ad_url varchar(100),
  ad_desc_url varchar(100),
  ad_copy varchar(100),
  min_money int,
  store_id varchar(10),
  order_num varchar(10),
  user_id varchar(10),
  city_id varchar(10),
  idu_category varchar(10),
  click_hide int,
  price int,
  sys varchar(10),
  network varchar(10),
  user_gender varchar(20),
  payment_kind varchar(20),
  primary key (ad_id)
);

truncate ad_info;

load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/aug-ad-info-with-tags.csv'
    into table ad_info
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;

# Check that the data was loaded
select * from ad_info limit 25;
select count(*) from ad_info; # 736 rows in total
select count(*)
from ad_info
where ad_desc_url ='';
/************************************************/

-- Create and load clicks table
create table if not exists clicks(
  click_time datetime,
  payment_time datetime not null,
  user_id varchar(10) not null,
  store_id varchar(10),
  ad_id varchar(10),
  primary key (payment_time, user_id)

);

truncate clicks;

# load click-01-09
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/aug-click-01-09.csv'
    into table clicks
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;
# load click-10
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/aug-click-10.csv'
    into table clicks
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;
# load click-11-31
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/aug-click-11-31.csv'
    into table clicks
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;

# Check that the data was loaded
select * from clicks limit 25;
select count(*) from clicks; # 2931445 rows in total
/************************************************/

-- Create and load views table
create table if not exists views (
  view_time datetime,
  payment_time datetime not null,
  user_id varchar(10) not null,
  store_id varchar(10),
  ad_id varchar(10),
  primary key (payment_time, user_id)
);

truncate views;

# load view-01-09
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/aug-view-01-09.csv'
    into table views
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;
# load view-10
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/aug-view-10.csv'
    into table views
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;
# load view-11-31
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/aug-view-11-31.csv'
    into table views
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;

# Check that the data was loaded
select * from views limit 25;
select count(*) from views; # 35767837 rows in total
/************************************************/

-- Create and load transactions table
create table if not exists transactions (
  user_id varchar(10) not null,
  payment_time datetime,
  money int,
  kind_pay varchar(10),
  kind_card varchar(10),
  store_id varchar(10) not null,
  network varchar(10),
  industry varchar(10),
  gender varchar(10),
  address varchar(100),
  primary key (user_id,store_id)
);

truncate transactions;

# load re-4
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/re/4.new.csv'
    into table transactions
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;
# load re-5
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/re/5.new.csv'
    into table transactions
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;
# load re-6
load data local infile
    'H:/Data Science/Week7/midterm_ctr_data_b15/midterm_ctr_data/re/6.new.csv'
    into table transactions
    character set 'utf8mb4'
    fields terminated by ','
    enclosed by '"'
    lines terminated by '\n'
   ;

# Check that the data was loaded
select * from transactions limit 25;
select count(*) from transactions; # 55118357 rows in total

/***********************************************************************************************************************
3. Run database queries to prepare modelling datasets
***********************************************************************************************************************/

-- How many days of data is there (in transactions table)?
select count(distinct date(payment_time))
from transactions;
# 45 days
/************************************************/

-- Data is filtered down to only one day '2017-08-01 00:00:00' to '2017-08-01 23:59:59'
drop table if exists txn;
create temporary table txn
select *
from transactions
where date(payment_time) = '2017-08-01'
order by payment_time;

drop table if exists view;
create temporary table view
select view_time,
       payment_time,
       user_id,
       ad_id
from views
where date(payment_time) = '2017-08-01'
order by payment_time;

drop table if exists click;
create temporary table click
select click_time,
       payment_time,
       user_id,
       ad_id
from clicks
where date(payment_time) = '2017-08-01'
order by payment_time;

-- create ctr_data table by joining txn, click and view tables.
drop table if exists ctr_data;
create table if not exists ctr_data
    select *,
           case when click_time > view_time then 1 # create a label column: click after view as 1
           else 0 end click_label
    from txn
        left join view using(payment_time, user_id)  # duplicated columns are removed
        left join click using(user_id, payment_time, ad_id) # duplicated columns are removed
        order by payment_time, view_time, click_time, user_id;

select * from ctr_data limit 25;
/************************************************/