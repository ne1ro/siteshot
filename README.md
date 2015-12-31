SiteShot
========

Single-page web site snapshot script.

Useful for SEO in single-page apps (Angular.js, Backbone.js, React, Flux, etc...)

## Installation
1. Install Node.js
2. Install SiteShot:

  	```
  	npm install siteshot -g
  	```  	
3. Create config in your website dir: 
  	
  	```
  	siteshot config
  	```  
  	You can modify `config.js` file to set up delay or provide custom modifying function:  
  
  	```javascript
  	module.exports = {
    	snapshotDir: "/var/www/APPLICATION_NAME/shadow-copy/snapshots",  
    	sitemap: "/var/www/APPLICATION_NAME/shadow-copy/sitemap.xml",  
    	delay: 5000,  
    	pageModifier: function(page, callback) {
      		page.evaluate(function() {
      			$('meta[name=fragment]').remove()
      		});
      		callback();
    	}
  	}
  	```
4. Finally, run util and get snapshots:

  	```
  	siteshot
  	```

Created by Alexey Kuznetsov © 2014
