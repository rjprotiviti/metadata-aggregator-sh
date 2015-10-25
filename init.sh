#make directories
mkdir /etc/repos/chef/
mkdir /etc/chef
mkdir /etc/chef/src
mkdir /etc/chef/src/cookbooks
mkdir /etc/chef/src/data_bags
mkdir /etc/chef/src/roles
mkdir /etc/chef/src/cookbooks/common
mkdir /etc/chef/src/cookbooks/common/recipes

#get recipes
git clone "https://metadata-aggregator-chef:$1@github.com/GSA/metadata-aggregator-chef.git"

#copy recipes
cp -i /etc/repos/chef/solo.rb /etc/chef/
cp -i /etc/repos/chef/src/cookbooks/common/recipes/default.rb /etc/chef/src/cookbooks/common/recipes/
cp -i /etc/repos/chef/src/cookbooks/recipes4recipes to /etc/chef/src/cookbooks/

#replace <token> with PAT value (parameter 1) in the /etc/chef/src/cookbooks/metadata-aggregator.rb file
find /etc -name /etc/chef/src/cookbooks/metadata-aggregator.rb -exec sed -i "s/<token>/$1/g" {} \;

chef-solo -o 'recipe[common]'
chef-solo -o 'recipe[recipes4recipes]'  
chef-solo -o 'recipe[java]'
chef-solo -o 'recipe[tomcat]'
chef-solo -o 'recipe[metadata-aggregator]'
