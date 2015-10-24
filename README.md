## Health Hack 2015 

#### This is our server

`ssh $USER@146.118.98.44`

## Our whiteborad plan

![whitetboardplan](supplementary/whiteBoardPlan.png)

## Aims:

- To write file parsers to parse fastqc, vcf and coverage files
- To write parsed output into mongoDB
- To query the database to extract the relevant info
- To visualise relevant information

## Instructions for creating and using mongoDB

```Python

from pymongo improt MongoClient

connection = MongoClient("mongo://localhost:27017")

db_test = connection.healthhack.test

test_dict = {}

db_test.insert(test_dict)

results = db_test.find()

for result in results:
    print result
```
## Git how to

1. fork https://github.com/serine/HeHackSheHack this repo to your github
2. git clone yourv version https://github.com/YOURUserName/HeHackSheHack.git
3. don't delete anyfiles just add your code files to that repo
4. `git add` your files `git commit -m ` your files
5. `git push` your files to your own repo
6. send pull request

## Hosting files from the server

If you like to host html or any other files put them into `~/www` directory
and access it as such `http://146.118.98.44/home/$USER/yourFile.html`
