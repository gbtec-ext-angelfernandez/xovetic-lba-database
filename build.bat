set VERSION=1.0.0
set BRANCH_NAME=development

echo Build docker image
docker build -t quay.io/repository/gbtec_ext_angelfernandez/xovetic-lba-database:%VERSION%-%BRANCH_NAME% .
echo Push docker image
docker push quay.io/repository/gbtec_ext_angelfernandez/xovetic-lba-database:%VERSION%-%BRANCH_NAME%