#!/bin/bash
sfdx force:org:create -f config/project-scratch-def.json  --setdefaultusername -d 1 -a TSTDeploy

#Install LMA Package
sfdx force:package:install -p 04t30000001DWL0 -w 20 

#Install App Analytics Package v 1.7
sfdx force:package:install -p 04t3i000002KWaC -w 20

#Insert Sample Data
sfdx force:data:tree:import -p ./demoAssets/data/plan.json

#Push Source
sfdx force:source:push -f

#Grant Permission
sfdx force:user:permset:assign -n AppAnalytics

#Assign Integration User Permissions
sfdx force:apex:execute -f ./demoAssets/scripts/AssignIntegrationUserPerms.apex 


#Push TCRM assets
sfdx force:source:deploy -p wave-app/main/default/wave/


#Reset Password
sfdx force:apex:execute -f ./demoAssets/scripts/adminpwreset.apex 


#Open Org
sfdx force:org:open 
