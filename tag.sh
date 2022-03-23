#!/bin/bash
#

#说明
show_usage="args: [-m , -q, -d, -t]\
                                  [--main_branch=, --qa_branch=, --dev_branch=, --]"
# 参数
#
# 说明：release GA 版本用的分支
main_branch=""
# 参数
#
# 说明：qa测试用用的分支
qa_branch=""
# 参数
#
# 说明：开发提交代码用的分支
dev_branch=""
# 参数
#
# 说明：交付版本号
version=""
# 参数
#
# 说明：交付版本号
tag=""

GETOPT_ARGS=`getopt -o m:q:d:t: -al package_file:,namespace: -- "$@"`
eval set -- "$GETOPT_ARGS"
#获取参数
while [ -n "$1" ]
do
        case "$1" in
                -p|--package_file) opt_package_file=$2; shift 2;;
				-n|--namespace) opt_namespace=$2; shift 2;;
                --) break ;;
                *) echo $1,$2,$show_usage; break ;;
        esac
done

if [[ -z $opt_package_file || -z $opt_namespace ]]; then
        echo $show_usage
        exit -1
fi

echo '======1.tag======'
git checkout $main_branch
git status

git pull -r

git tag $tag

git push --tags

echo '======2.rebase to dev======'
git checkout newten-dev

git pull -r newten

echo '======3.drop dev======'
git push origin --delete newten-dev