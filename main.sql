-- drop database raw_stage
create database if not exists raw_stage;

-- drop stage if exists raw_stage.PUBLIC.stg;
CREATE STAGE if not exists raw_stage.PUBLIC.stg
url = 'azure://your-account.blob.core.windows.net/your_container'
CREDENTIALS = (AZURE_SAS_TOKEN='sp=racwdl&st=token')

list @raw_stage.PUBLIC.stg


-- drop file FORMAT RAW_DB.PUBLIC.JSON 
CREATE FILE FORMAT if not exists RAW_DB.PUBLIC.JSON 
TYPE = 'JSON' 
COMPRESSION = 'AUTO' 
ENABLE_OCTAL = FALSE 
ALLOW_DUPLICATE = FALSE 
STRIP_OUTER_ARRAY = FALSE 
STRIP_NULL_VALUES = FALSE 
IGNORE_UTF8_ERRORS = FALSE;


SELECT
    *
FROM @raw_stage.PUBLIC.stg
(
  file_format => RAW_DB.PUBLIC.JSON ,
  pattern => 'sample.json'
);


SELECT
     $1[0]:completed
    ,$1[0]:title
FROM @raw_stage.PUBLIC.stg
(
  file_format => RAW_DB.PUBLIC.JSON ,
  pattern => 'sample.json'
);


SELECT
      value:completed::string as completed
     ,value:id::bigint as id
     ,value:title::string as title
     ,value:userId::bigint as user_id
FROM @raw_stage.PUBLIC.stg
(
  file_format => RAW_DB.PUBLIC.JSON ,
  pattern => 'sample.json'
),
lateral flatten( input => parse_json($1));


with cte_result as (
SELECT
      value:completed::string as completed
     ,value:id::bigint as id
     ,value:title::string as title
     ,value:userId::bigint as user_id
FROM @raw_stage.PUBLIC.stg
(
  file_format => RAW_DB.PUBLIC.JSON ,
  pattern => 'sample.json'
),
lateral flatten( input => parse_json($1))
)
select * from cte_result;