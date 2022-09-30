# _Snowpipe with Terraform_  

By running these modules, we utilise AWS services (IAM roles/policies, SNS to which Snowflake's SQS subscribes) and Snowflake to build an event-based pipeline to continuously ingest data into Snowflake as soon as data is available in AWS S3 staging buckets.  

These terraform modules automate Snowpipe using Amazon SQS by creating Snowflake's stage, pipes, tables, and storage integration. 

  
---

## File structure  

Here is the structure of this repo:  

.  
-- setup  
&nbsp; &nbsp; &nbsp; &nbsp; |-- sample_app_1  
&nbsp; &nbsp; &nbsp; &nbsp; |-- sample_app_2  
&nbsp; &nbsp; &nbsp; &nbsp; ...  
&nbsp; &nbsp; &nbsp; &nbsp; |-- sample_integration   
&nbsp; &nbsp; &nbsp; &nbsp; ...  
-- snowflake-modules  
&nbsp; &nbsp; &nbsp; &nbsp; |-- pipe  
&nbsp; &nbsp; &nbsp; &nbsp; |-- stage  
&nbsp; &nbsp; &nbsp; &nbsp; |-- table  
&nbsp; &nbsp; &nbsp; &nbsp; |-- storage-integration  


(Note)  
1. We decoupled snowflake integration from stage/pipe/table creation. In other words, we first create an integration, and then create stage/pipes/tables:  
* setup/sample_integration : to create a snowflake integration.  
So, in order to setup a new pipeline, most of the cases, we need to run both sample_app and sample_integration. However, just to add a new app events, we can use an existing integration by feeding the integration info (intergation and sns topic names) when we do terraform apply for sample_app. 
* setup/sample_app : for app events. The sample_app_1 and sample_app_2 can opt to use different buckets listed as STORAGE_ALLOWED_LOCATIONS in the Snowflake integration.   
 

2. Another thing to notice about an integration is that just creating a new integration does not automatically subscribe the Snowflake SQS Queue to the SNS Topic. We need to create an app (Snowflake stage/pipe/table) using the integration.


3. The root modules are under "setup" folder.  
So, if we want to create stage/pipe/table for event ingestion from sample_app_1, we can use terraform configurations under sample_app_1. Just go into to that directory and issue "terraform init/plan/apply" commands there. The configurations in the sampel_app_ folder call child modules defined in stage/pipe/table in ../snowflake-modules. If we want to process events from a new sample_app_2, we can copy terraform the configurations from an existing app such as sample_app_1 and modify inputs defined in {env}.tfvars and terraform states location defined in main.tf. Then, run terraform under the new app folder, sample_app_2.  


4. If we need to create another integration, do the same after creating a new integration folder setup/integration_.  

---

## Modules  
Here are the summay of what each module does:  


### Snowflake's storage-integration module  
1. Snowflake Storage Integration with AWS (IAM, S3, SNS with Snowflake's SQS). 
2. AWS SNS topic with a subscription from Snowflake's SQS.  
3. AWS IAM Role with an appropriate policy required to access the S3 bucket.  This role constructs a trust relationships so that Snowflake can assumes this role.  
4. Trust relationships between the Snowflake Storage integration and AWS IAM Role.  


### Snowflake's stage/pipe/table modules  
1. Creates a stage, pipes, and tables  

---

## Prerequites:  
1. Terraform > 1.2.8  
2. Create a key pair for snowflake with appropriate permissions. See "References" for supported on the private key. 
3. Set environmental variables, for example:  
* export SNOWFLAKE_USER=snow_dev  
* export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE=UNX****s2Z  
* export SNOWFLAKE_PRIVATE_KEY_PATH=/Users/khong@bogotobogo.com/.ssh/sa_dev.p8  
* export SNOWFLAKE_ACCOUNT=iz******  
4. For the Snowflake pipeline to work, S3 subfolders as a prefix (app_name/events/) should exist under a specified bucket (apps_bucket_name) so that we can create a succesful S3 path with the key and prefix, for example, s3://{apps_bucket_name}/{app_name}/{events}/.  


---


## Run:  
1. To create a new integration, run setup/integration first and then run setup/sample_app. To use an existing integration, just modify the variables such as integration/sns names in {env}.tfvars in setup/sample_app folder and run it. 

2. The root module is in setup/sample_app_name/ and this is the location where we run terraform. So, 'cd' into that folder and this is our root project directory.  

3. Child modules are located at snowflake-modules. These modules create a snowflake intergation, a stage, pipes, and tables. The integration module creates an SNS topic subscribed by SQS and an IAM role that grants read access to the staging bucket. Snowflake assumes this role to access the external stage. This can be run within "sample_integration".  

4. Running **Integration**  
Before we run terraform for an integration, we need to set variables. They are declared in sample_integration/variables.tf and defined in {env}.tfvars which is the file we want to modify:  
* snowflake_account - ta snowflake account and we do not want to modify this.  
* prefix - used to name integration related resources such as snowflake integration, s3_reader_role_name, s3_sns_policy_name, s3_bucket_policy_name, and s3_sns_topic_name. 
* snowflake_storage_integration_owner_role - a Snowflake role provided by an Admin.  
* aws_region - AWS region.   
* buckets - list of S3 bucket names that is used to set STORAGE_ALLOWED_LOCATIONS for Snowflake integration.  
Also, we need to modify the remoteTerraform state file location in S3 defined in main.tf.  


5. Running **Application**  
Before we run terraform for an integration, we need to set variables. They are declared in sample_app/variables.tf and defined in {env}.tfvars which is the file we want to modify:   
Note that these variables override the variables defined for each child module in ../snowflake-modules/  
* snowflake_account - ta Snowflake account and we do not want to modify this.  
* apps_bucket_name - used to define snowflake external stage(S3). From this input, the stage module constructs bucket_url as locals to setup STAGE_LOCATION internally. For example, s3://{apps_bucket_name}.  
* app_name - app name, used to name pipe, table, stage etc. This should match the pre-existing app name subfolder of the S3 bucket. For example, s3://{apps_bucket_name}/{app_name}/.  
* events [] - this should match the pre-existing subfolders under app name key. For example, s3://{apps_bucket_name}/{app_name}/{events}/.  
* event_file_format - either json or csv. 
* storage_integration_name - used as an input for snowflake stage module. This info is available output from "terraform apply" under setup/sample_integration.  
* sns_topic_name - used as an input for snowflake pipes module. This info is available output from "terraform apply" under setup/sample_integration.   
* snowflake_db_name - snowflake db name.  
* snowflake_schema_name - snowflake schema name.  
  
6. We're using S3 remote backend for Terraform state located in "terraform {}" block at the top of setup/main.tf. We need to modify the S3 backend bucket/prefix to match the state file stored in terraform-state/snowpipe/app_name/terraform.tfstate. If the app_name folder if not there, we want to create it in S3.

7. On the project root directory (setup/sample_app to register process events, setup/integration to create/update integration), run 'terraform init', 'terraform plan', and 'terraform apply' with an argument of "-var-file={env}}.tfvars" in that order.   

---

## Debugging ##  
While running the integration and application, we may have the following issues:  

1. There is no Snowflake's SQS subscription to a SNS topic. This happens when there is no application that utilize the integration. Snowflake appears to be checking if the pipe line is in place before the subscription confirmation. So, we need to create an application with Snowflake pipes (run setup/sample_app).  

2. When we run an app, we want to check the inputs in setup/sample_app/{env}.tfvars whether the integration and the SNS names are exist. Terrafrom complains about them, for example, "no matching SNS Topic found" when there is no such SNS topic defined in the {env}.tfvars. 

3. Because we store the Terraform state in remote S3, we need to modify the location in main.tf under setup/, otherwise we will get an error when we do "terraform init".  

4. S3 event notification related issues:  
If a Snowflake table is not updated after a file is dropped into S3 bucket, we can check whether the notification is broken or not by running a COPY statement from a snowpipe on Snowflake such as DBeaver. Just get a COPY statement from "describe pipe pipe_name". If that updates the table successfully, we can be sure the notification is broken. If not, we should check the Snowflake pipe lines one by one such as integration/stage/pipe whether they are set properly.  

---

## Terminologies ##  


**Stage**:  
A space where we can upload files - they can be either internal (in Snowflake) or external (S3).
An external stage that we're using references data files stored outside of Snowflake in a cloud storage service such as AWS S3.  
Note that many external stage objects can reference different buckets and paths and use the same storage integration for authentication.  


**Pipe**:  
A continuous ingestion service that loads our data into tables. 
Snowflake pipe is a serverless feature in Snowflake that loads data as soon as it is available in an external stage.  
Actually, the pipe is simply a COPY statement that copies the data from the external stage into the destination table.  


**Storage integration**:  
Storage integration allows Snowflake to read data from and write data to an Amazon S3 bucket referenced in an external (i.e. S3) stage.  
Integration objects store an AWS identity and access management (IAM) user ID to avoid the need for passing explicit cloud provider credentials such as secret keys or access tokens.  
Snowflake automatically associates the storage integration with a S3 IAM user created for TA AWS account. Snowflake creates a single IAM user that is referenced by all S3 storage integrations of a  Snowflake account.  


---


## References ##

[Snowflake-Labs/terraform-snowflake-storage-integration-aws](https://github.com/Snowflake-Labs/terraform-snowflake-storage-integration-aws/tree/v0.2.2).  

[Snowflake Provider](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs).  

[Keypair Authentication Passphrase](https://registry.terraform.io/providers/Snowflake-Labs/snowflake/latest/docs). 

[Configuring a Snowflake Storage Integration to Access Amazon S3](https://docs.snowflake.com/en/user-guide/data-load-s3-config-storage-integration.html).



