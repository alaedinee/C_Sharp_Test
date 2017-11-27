var AccountSetupForm = (function () {
    return {
        init: function () {
        },
        displayPopUpWindow: function (firstName, lastName) {

            var postData = {
                firstName: firstName,
                lastName: lastName
            };

            $.post("/GetNewAccountViewHtml", postData, function (data) {
                $.telerik.window.create({
                    title: "Sample Window",
                    html: unescape(data.viewHtml),
                    modal: true,
                    resizable: false,
                    visible: false,
                    width: 500,
                    height: 200
                })
            .data('tWindow').center().open();
            });
        }
    };

})();

$(document).ready(function () {
    AccountSetupForm.init();
});