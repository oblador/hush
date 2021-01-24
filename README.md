<div align="center">
  <a href="https://oblador.github.io/hush/"><img src="https://user-images.githubusercontent.com/378279/102943111-6dfe0500-44b7-11eb-9e9a-1c77d53a04ab.png" width="256" height="256"></a>
  <h1>Hush</h1>
  <p>
    <b>Block nags to accept cookies and privacy invasive tracking in Safari</b>
  </p>
  <br>
  <br>
  <br>
</div>

>I’d recommend Hush to anyone who uses Safari

– John Gruber, [Daring Fireball](https://daringfireball.net/linked/2021/01/23/hush) 23 January 2021

Hush is private, free and fast – [read more on the website](https://oblador.github.io/hush/).

## Download

### iOS

[![](https://linkmaker.itunes.apple.com/assets/shared/badges/en-us/appstore-lrg.svg)](https://apps.apple.com/app/id1544743900)

Requires iOS 14 or later.

### macOS

[![](https://linkmaker.itunes.apple.com/assets/shared/badges/en-us/macappstore-lrg.svg)](https://apps.apple.com/app/id1544743900)

Requires macOS 11 or later. [Direct download](https://github.com/oblador/hush/releases/latest/download/Hush.dmg).

## Screenshots

<img width="432" src="https://user-images.githubusercontent.com/378279/102943263-da790400-44b7-11eb-9c4e-ee6870da3c24.png">

## Features

### Private
Unlike some blockers, Hush has absolutely no access to your browser habits or passwords. Nor does it track behavior or collect crash reports - nothing leaves your device.

### Free
Everything is free of charge. Forever. No in-app purchases, no nonsense. However, any help towards covering the yearly Apple Developer fee is greatly appreciated.

### Fast
The app is primarily a host of rules that integrates with Safari in a native, lightweight way, making the blocking efficient and fast.

### Simple
It's as easy as downloading the app and enabling it in Safari settings ⭢ Content Blockers. No configuration or maintenance needed.

### Open Source
The source code is published under the permissive MIT license.

### Modern
Hush is written in Apple's latest programming paradigm Swift UI and has native support for M1 processors.

### Tiny
The app download clocks in at less than half a megabyte.

## FAQ

#### Does Hush accept or deny permission to site cookies?

Neither! Hush will block specific scripts and elements on the website, but can't and won't interact with the website itself and thus won't click on any buttons. According to GDPR laws the user needs to explicitly consent to non-essential cookies and tracking.

#### Can't websites still use cookies/tracking without my consent?

Absolutely, being compliant and respecting your choices is up to the website owners. It's possible to block all cookies, but that also breaks a lot of websites. I personally use incognito mode so I don't have to trust website owners' good intents and implementations, but that means they constantly "forget" my cookie choices. Ergo Hush.

#### Does it block ads?

Hush doesn't block ads on purpose. Nobody wants to read nor display cookie notices. But ads – however annoying – might be crucial for makers and businesses on the internet and I don't want to steal their lunch.

#### Why does website X display nags with Hush enabled?

On some sites it's not possible to block/hide cookie notices or tracking consent screens without also breaking the site. Other sites have obfuscations in place to prevent blocking. Regardless, you may open an issue on GitHub or [fill in a form](https://docs.google.com/forms/d/e/1FAIpQLSeox139lwja1Yl94dIZLSg8Ga8Wt4PAWSmRwtIe7NPb7WtHMA/viewform) to report it.

#### Why does website X break with Hush enabled?

First ensure that it's actually Hush breaking it by disabling it in settings and reloading the page. If it works after this, please report it by opening an issue.

## Building from source

To build the app in Xcode, you need to have [deno](https://deno.land) installed first:

```sh
brew install deno
xcode-select --install
```

## Contributing

### Tests

Run blocklist unit tests with:
```bash
make test_unit
```

Run UI tests with:

```bash
make test_ui
```

### Blocklist

Compile blocklist only with (part of Xcode build):
```bash
make blocklist
```

## License

Hush: [MIT License](http://opensource.org/licenses/mit-license.html). © Joel Arvidsson 2020-present

[Fanboy List](https://easylist.to): [CC BY 3.0](https://creativecommons.org/licenses/by/3.0/). © Rick Petnel and contributors 2005
