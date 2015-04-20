# webdriver cdn

一个简单的 [protractor](https://github.com/angular/protractor) webdriver-manager CDN 。

嗯，需要自己部署。

然后可以每个小时跑一次：

```crontab
0 * * * * /usr/bin/ruby $HOME/webdriverCDN/main.rb >> $HOME/webdriverCDN/crontab.log
```

顺便每天 pull 一次好了：

```crontab
0 0 * * * {cd $HOME/webdriverCDN/ && git fetch origin && git reset --hard origin/master} >> $HOME/webdriverCDN/crontab.log
```
