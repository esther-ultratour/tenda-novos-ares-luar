# Trechos para colar no 3DVista — Novos Ares Luar

Copie daqui. Cada bloco é independente.

---

## 1. Loader — cole no **JavaScript global do projeto** (roda uma vez)

```js
(function(){
  var s = document.createElement('script');
  s.src = 'https://skylineip.s3.sa-east-1.amazonaws.com/Tour+Virtual/TENDA/ferramentas/galeria/novos+ares+luar/inject.js?v=' + Date.now();
  document.head.appendChild(s);
})();
```

---

## 2. Galerias — cole na **action** do hotspot/botão

Abrir a galeria de imagens:

```js
GaleriaImagens(1);
```

Fechar a galeria de imagens:

```js
GaleriaImagens(0);
```

Abrir a galeria do apartamento decorado:

```js
GaleriaApartamento(1);
```

Fechar a galeria do apartamento decorado:

```js
GaleriaApartamento(0);
```

Abrir a galeria de plantas:

```js
GaleriaPlantas(1);
```

Fechar a galeria de plantas:

```js
GaleriaPlantas(0);
```
