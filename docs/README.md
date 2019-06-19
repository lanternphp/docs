---
home: true
heroImage: /logo.svg
actionText: Get started →
actionLink: /documentation/
footer: MIT Licensed | Copyright © 2019-present Kelvin Jones
example-screenshot: https://carbon.now.sh/embed/?bg=rgba(74%252C144%252C226%252C0)&t=one-dark&wt=none&l=text%252Fx-php&ds=false&dsyoff=20px&dsblur=68px&wc=true&wa=true&pv=26px&ph=34px&ln=false&fm=Fira%2520Code&fs=14px&lh=152%2525&si=false&es=2x&wm=false&code=%25253C%25253Fphp%25250A%25250Anamespace%252520App%25255CFeatures%25253B%25250A%25250Ause%252520Lantern%25255CFeatures%25255CFeature%25253B%25250A%25250Aclass%252520ManagingUsersFeature%252520extends%252520Feature%25250A%25257B%25250A%252520%252520%252520%252520const%252520DESCRIPTION%252520%25253D%252520'Actions%252520for%252520managing%252520users'%25253B%25250A%25250A%252520%252520%252520%252520const%252520ACTIONS%252520%25253D%252520%25255B%25250A%252520%252520%252520%252520%252520%252520%252520%252520ListCompanyUsers%25253A%25253Aclass%25252C%25250A%252520%252520%252520%252520%252520%252520%252520%252520CreateCompanyUser%25253A%25253Aclass%25252C%25250A%252520%252520%252520%252520%252520%252520%252520%252520UpdateCompanyUser%25253A%25253Aclass%25252C%25250A%252520%252520%252520%252520%252520%252520%252520%252520ListProjectUsers%25253A%25253Aclass%25252C%25250A%252520%252520%252520%252520%252520%252520%252520%252520CreateProjectUser%25253A%25253Aclass%25252C%25250A%252520%252520%252520%252520%252520%252520%252520%252520RemoveUserFromProject%25253A%25253Aclass%25252C%25250A%252520%252520%252520%252520%252520%252520%252520%252520AddUserToProject%25253A%25253Aclass%25252C%25250A%252520%252520%252520%252520%252520%252520%252520%252520ResendSetupEmail%25253A%25253Aclass%25250A%252520%252520%252520%252520%25255D%25253B%25250A%25257D 
---
<br>

### Why Lantern?  

Laravel is a _great_ framework that [has no opinion about how your application should be structured](https://laravel.com/docs/master/structure#introduction):

> The default Laravel application structure is intended to provide a great starting point for both large and small applications. But you are free to organize your application however you like.

This is a huge part of the attraction of Laravel; it allows a developer to express themselves. **Lantern is one such expression.** 

<div class="features"><div class="feature">

## 📢 Declarative

The ==features== and ==actions== of your app are explicitly declared to your Laravel app.
The functionality of your app becomes apparent just by looking at your file structure.
    
</div><div class="feature">

## 🏘️ Co-location

By ensuring each ==action== has its own class, it attracts the relevant behaviour.
For example, the code for the ==availability== of an ==action== sits alongside the ==action== itself, making it easier to reason about your application.

</div><div class="feature">

## 🏰 Laravel-powered

Lantern takes `advantage` of its deep integration with Laravel & its ecosystem to ensure your app always feels like a Laravel️ app. 

Start small with a single action:<br>
[Get started →](/documentation/installation) 👣

</div></div>

By following Lantern’s conventions in organising your domain code, you get extra stuff thrown in for free:

- [x] Easy to scan the file structure 
- [x] Apply system ==constraints== to an ==action== or ==feature==, such as whether a particular binary can be found
- [x] Restrict ==availability== of an ==action== according to the current user, the current state of your domain model …etc.  
- [x] Each ==action== registers an authorisation gate that can be checked from middleware, a controller, a blade template  
- [ ] Record the most recent ==actions== performed by each user 
- [ ] Add in session-level debug info to an exception when it occurs, e.g. the ==action== history of the user 
