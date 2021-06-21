CREATE STAGE raw_stage.PUBLIC.stg
url = 'azure://your-account.blob.core.windows.net/your_container'
CREDENTIALS = (AZURE_SAS_TOKEN='sp=racwdl&st=token')

