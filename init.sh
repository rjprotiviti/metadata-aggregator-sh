#make directories
mkdir /etc/repos/chef/
mkdir /etc/chef
mkdir /etc/chef/src
mkdir /etc/chef/src/cookbooks
mkdir /etc/chef/src/cookbooks/metadata-aggregator
mkdir /etc/chef/src/cookbooks/metadata-aggregator/recipes
mkdir /etc/chef/src/data_bags
mkdir /etc/chef/src/roles
mkdir /etc/chef/src/cookbooks/common
mkdir /etc/chef/src/cookbooks/common/recipes

#get recipes
cd /etc/repos/chef/
git init
git clone "https://metadata-aggregator-chef:$1@github.com/rjprotiviti/metadata-aggregator-chef.git"
cd /etc/repos/chef/metadata-aggregator-chef



#copy recipes
cp -i /etc/repos/chef/metadata-aggregator-chef/solo.rb /etc/chef/
cp -i /etc/repos/chef/metadata-aggregator-chef/src/cookbooks/common/recipes/default.rb /etc/chef/src/cookbooks/common/recipes/



#get jdk and tomcat recipes
cd /etc/chef/src/cookbooks
wget -O java 'https://supermarket.chef.io/cookbooks/java/download' 
tar -xvzf java
wget -O tomcat 'https://supermarket.chef.io/cookbooks/tomcat/versions/0.17.0/download' 
tar -xvzf tomcat

#copy metadata-aggreator.rb to working folder
cp -i /etc/repos/chef/metadata-aggregator-chef/src/cookbooks/metadata-aggregator/recipes/default.rb to /etc/chef/src/cookbooks/metadata-aggregator/recipes/

#replace <token> with PAT value (parameter 1) in the /etc/chef/src/cookbooks/metadata-aggregator.rb file
find /etc/chef/src/cookbooks -name default.rb -exec sed -i "s/<token>/$1/g" {} \;


#run recipes
chef-solo -o 'recipe[common]'
chef-solo -o 'recipe[java]'
chef-solo -o 'recipe[tomcat]'
chef-solo -o 'recipe[metadata-aggregator]'
