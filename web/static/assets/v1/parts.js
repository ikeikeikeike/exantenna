;(function() {
    var p = location;
    if (document.currentScript) {
        p = document.createElement('a');
        p.href = document.currentScript.getAttribute("src")
    }
    var BASE_URL = p.protocol + '//' + p.host;
    var FALLBACK = 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAANSURBVBhXYzh8+PB/AAffA0nNPuCLAAAAAElFTkSuQmCC';

    function createHttpRequest() {
        var xmlhttp = null;
        if (window.ActiveXObject) {
            try {
                xmlhttp = new ActiveXObject("Msxml2.XMLHTTP")
            } catch (e) {
                try {
                    xmlhttp = new ActiveXObject("Microsoft.XMLHTTP")
                } catch (e2) {}
            }
        } else if (window.XMLHttpRequest) {
            xmlhttp = new XMLHttpRequest()
        }
          // else {}
        // if (!xmlhttp) {}

        return xmlhttp
    }

    function sendRequest(method, url, data, async, callback) {
        var xmlhttp = createHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4) {
                callback(xmlhttp)
            }
        };
        xmlhttp.open(method, url + '?' + data, async);

        xmlhttp.withCredentials = false;
        xmlhttp.setRequestHeader('X-Requested-With', 'XMLHttpRequest');
        xmlhttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xmlhttp.send(data)
    }

    function cleanWordPaste(in_word_text) {
        var tmp = document.createElement("div");
        tmp.innerHTML = in_word_text;
        var str = tmp.textContent || tmp.innerText;
        str = str.replace(/\n\n/g, "<br />").replace(/.*<!--.*-->/g, "");
        for (i = 0; i < 10; i++) {
            if (str.substr(0, 6) == "<br />") {
                str = str.replace("<br />", "")
            }
        }
        str = str.split(/[\s,]+/).join(" ");
        str = str.split(/\r?\n/).join(" ").split(',').join(" ");
        str = str.split("?").join(" ").split('&').join(" ");
        return str
    }

    function createElement(tagName, attributes) {
        var o = document.createElement(tagName),
            i;
        attributes = attributes || {};
        for (i in attributes) {
            o.setAttribute(i, attributes[i])
        }
        return o
    }

    function getRandomInt(min, max) {
      return Math.floor( Math.random() * (max - min + 1) ) + min;
    }

    function appendStylesheet(href) {
        var head = document.getElementsByTagName("head")[0];
        var link = createElement("link", {
            href: href,
            rel: "stylesheet",
            type: "text/css"
        });
        head.appendChild(link)
    }

    var i, c, data, result, words = [],
        elem = document.body.getElementsByTagName("*");

    for (i = 0; i < elem.length; i++) {
        c = elem[i];
        if (c.children.length === 0 && c.textContent.replace(/ |\n/g, '') !== '') {
            words.push(c.textContent)
        }
    }

    setTimeout(function() {
        appendStylesheet(BASE_URL + "/v1/parts.css");
        result = document.getElementById("exta-fire-elems__");

        data = "v=1";
        data += "&per_item=" + (result.getAttribute("data-per-item") || 5);
        data += "&media_type=" + (result.getAttribute("data-media-type") || '');
        data += "&adsense_type=" + (result.getAttribute("data-adsense-type") || '');

        sendRequest("GET", BASE_URL + "/v1/parts.json", data, true, function(resp) {
            var rootdiv = document.createElement("div"),
                objs = JSON.parse(resp.responseText),
                thumblink, listdiv, socialdiv, captiondiv, img, h3, boxSize, a, i, d, obj, p;

            rootdiv.id = 'ext-elems__';
            rootdiv.className = 'none__';

            for (i = 0; i < objs.length; i++) {
                obj = objs[i];

                thumblink = document.createElement("a");
                thumblink.target = result.getAttribute("data-target-blank");
                thumblink.className = 'thumbnail__';
                if (result.getAttribute("data-box-design") === "cover" || result.getAttribute("data-box-social")) {
                    thumblink.className += ' cover__'
                }
                thumblink.href = BASE_URL + '/s/' + obj.id;

                img = document.createElement("img");
                if (obj.thumbs[0]) {
                  var cnt = 0;

                  img.src = obj.thumbs[cnt];
                  img.onerror = function() {

                    if (obj.thumbs.length < cnt) {
                      this.src = FALLBACK;
                      this.onerror = null;
                      return;
                    }

                    cnt++
                    this.src = obj.thumbs[cnt];
                  }
                }
                img.className = 'fade__';
                if (result.getAttribute("data-box-orient") === "horizontal-y150") {
                    img.className += ' horizontal-y150__'
                }

                thumblink.appendChild(img);
                if (result.getAttribute("data-box-social")) {
                    socialdiv = document.createElement("div");
                    socialdiv.className = 'social__';

                    if (result.getAttribute("data-box-social") === "twitter") {
                        socialdiv.className += ' twitter__';
                        socialdiv.innerHTML = (obj.twitterScore || getRandomInt(0, 200)) + 'RT'
                    } else if (result.getAttribute("data-box-social") === "facebook") {
                        socialdiv.className += ' facebook__';
                        socialdiv.innerHTML = (obj.facebookScore || getRandomInt(0, 50)) + 'Like'
                    } else if (result.getAttribute("data-box-social") === "hatena") {
                        socialdiv.className += ' hatena__';
                        socialdiv.innerHTML = (obj.hatenaScore || getRandomInt(0, 10)) + 'users'
                    } else if (result.getAttribute("data-box-social") === "score") {
                        socialdiv.className += ' score__';
                        socialdiv.innerHTML = (obj.inScore || getRandomInt(0, 30)) + 'PV'
                    }

                    thumblink.appendChild(socialdiv)
                }

                captiondiv = document.createElement("div");
                captiondiv.className = 'caption__';
                if (result.getAttribute("data-box-design") === "cover") captiondiv.className += ' cover__';

                h3 = document.createElement("h3");
                h3.innerHTML = obj.metadata.title.substring(0, 30);
                if (result.getAttribute("data-box-design") === "cover") h3.className = 'cover__';

                captiondiv.appendChild(h3);
                thumblink.appendChild(captiondiv);
                listdiv = document.createElement("div");
                boxSize = parseFloat(result.getAttribute("data-box-size"));

                if (result.getAttribute("data-box-orient") !== "vertical") {
                    boxSize = (boxSize || 20.0)
                } else {
                    boxSize += boxSize ? 80.0 : 100.0
                }

                listdiv.style.width = boxSize + '%';
                listdiv.className = 'col-middle__';
                if (result.getAttribute("data-box-orient") !== "vertical") {
                    listdiv.className += ' col-middle-horizontal__'
                }

                listdiv.appendChild(thumblink);
                rootdiv.appendChild(listdiv)
            }

            result.parentNode.insertBefore(rootdiv, result)
        })

    }, 1)
})();
