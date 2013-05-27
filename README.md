# server-essentials cookbook

# Requirements

# Usage

# Attributes

# Recipes

# Author

Author:: Sidney Burks (<sid137@gmail.com>)


Learnings

# Recipe order


The include_recipe action doesn't work as you expect it to.  If you're trying
to use a definition or new resource at a future point in a recipe, it does not
work by simply saying "include_recipe 'resource-recipe'".  This is because of
chef's 2-phase compile/run process.  For some reason, it doesn't compile the
resources as it should, and therefore the resources aren't defined:


http://stackoverflow.com/questions/11380485/chef-why-are-resources-in-an-include-recipe-step-being-skipped
http://docs.opscode.com/resource_common_compile.html

As a result, you MUST run the recipe in a run_list before calling the recipe
that you actually want to use the resource in.

This is particularly painful when trying to use the fnichols/chef-user
cookbook, and is possibly the reason why trying to use "line" failed to run in
a recipe defined further down the dependency chain

Tis really sucks, because if you use a cookbook as a dependency, that uses a
resource defined in another cookbook that it has as a dependency, then YOUR
RUN WILL FAIL!  As a result, you now need to:
   1. parse through the code in all of the cookbooks that you use as dependencies, 
   2. figure out whats a resource or definition that it relies on another
      cookbook to use
   3.figure out where to get this cookbook, and how to run it
   4. specifically run that cookbook in your run_list

   ie -  The dependency handling magic that you hope for, isn't there 


   However...why can I use the line recipe but not the user recipe?....weird..



# Setting up a new project

Requirements:
knife-solo v> 0.3.0
   Versions of knife solo prior to this don't support Berkshelf style
   cookbooks.  As a result, prior, you have to vendor the cookbooks into a
   "cookbooks" directory before trying to provision the server

Berkshelf
  "berks install" and "berks update" do NOT update your cookbooks.

  Berks install downloads all cookbooks to ~/.berkshelf and the ones cached in
  this location are then uploaded to the server for provisioning.  If you
  update the current cookbook locally, and want to retry it, Berkshelf uses the
  newer version.  However, if you make an update to a dependency cookbook, and
  push the update to github, running "berks update" or "berks install", or just
  rerunning chef will NOT use the updated dependency cookbook.

  As a result, you need to clean out the cached cookbooks before restarting the
  provisioning process.  The place absolutely necessary to clean is:
      rm -rf ~/.berkshelf/cookbooks

  You could also consider cleaning the cookbooks on the provisioned server by
  running:
     
    knife solo clean root@server

    however that doesn't seem absolutely necessary as of yet
    

Berksfile
Gemfile

nodes/default.json
   This is needed because knife-solo doesn't seem to know how to work without
   using a nodes/*.json file...  =\   it does not seem to pass additional
   command line options to knife or chef-solo.   Until this changes, any
   commands that rely on knife-solo need to have a nodes/*.json file with the
   run_list described.

   Note:  using an argument --run_list=...  does NOT work


