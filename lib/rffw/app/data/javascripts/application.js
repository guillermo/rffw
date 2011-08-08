(function() {




    Element.prototype.css = function(object) {
        for (property in object) {
            this.style.setProperty(property, object[property]);
        }
    };

    Element.prototype.toggle = function() {
        if (window.getComputedStyle(this, 'display') == "none") {
            this.show();
        } else {
            this.hide();
        }
    };

    Element.prototype.show = function() {
        this.style.setProperty("display", "block");
    };

    Element.prototype.hide = function() {
        this.style.setProperty("display", "none");
    };

    window.info = function(message) {
        var hover = document.getElementById('drop_the_file');
        if (message == undefined) {
            hover.classList.remove("show");

        } else {
            hover.innerHTML = message;
            hover.classList.add("show");
        }
    };
   
    window.onload = function() {

        function S4() {
            return (((1 + Math.random()) * 0x10000) | 0).toString(16).substring(1);
        }
        function new_guid() {
            return (S4() + S4() + "-" + S4() + "-" + S4() + "-" + S4() + "-" + S4() + S4() + S4());
        }

        document.getElementById("progress_bar").css({
            "display": "none"
        });


        window.uuid = new_guid();

        form = document.getElementById("uploader_form");
        form.action = form.action + "?" + window.uuid;

        description_form = document.getElementById("description_form");
        description_form.action = description_form.action + "?" + window.uuid;

        function check_status() {
            setTimeout(function() {
                var req = new XMLHttpRequest();
                req.open('GET', '/upload_status.js?' + window.uuid, true);
                req.onreadystatechange = function(aEvt) {
                    if (req.readyState == 4) {
                        if (req.status == 200) {

                            record = JSON.parse(req.responseText);
                            if (record.progress) {
                                var progress = record.progress.split("/");
                                var total = parseInt(progress[1],10);
                                var partial = parseInt(progress[0],10);
                                var porcentage = (100 * partial / total).toFixed();
                                if (porcentage > 100) porcentage = 100;

                                document.getElementById("porcentage").css({
                                    'width': porcentage + '%'
                                });
                                document.getElementById("total_uploaded").innerHTML = porcentage + '%';
                                check_status();
                            } else {
                                document.getElementById("porcentage").css({
                                    'width': '100%'
                                });
                                document.getElementById("total_uploaded").innerHTML = "Uploaded!";
                            }
                        }
                        else {
                            d("Error loading page\n");
                        }
                    }
                };
                req.send(null);
            },
            200);
        }

        form.onchange = function() {
            form.submit();
            document.getElementById("file_input").css({
                "display": "none"
            });
            document.getElementById("progress_bar").css({
                "display": "block"
            });
            check_status();
        };

        window.d = function(msg) {
            window.console.debug(msg);
        };




    };

})();
