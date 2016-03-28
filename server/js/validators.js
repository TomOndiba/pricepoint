/*
Contains functions that override default asp.net validator functions for enhanced UI experience.
*/

ValidatorUpdateIsValid = function () {
    Page_IsValid = AllValidatorsValid(Page_Validators);
    ClearValidatorCallouts();
    SetValidatorCallouts();
};

ValidatorValidate = function (val, validationGroup, event) {
    val.isvalid = true;
    if ((typeof (val.enabled) == 'undefined' || val.enabled != false) && IsValidationGroupMatch(val, validationGroup)) {
        if (typeof (val.evaluationfunction) == 'function') {
            val.isvalid = val.evaluationfunction(val);
            if (!val.isvalid && Page_InvalidControlToBeFocused == null &&
                typeof (val.focusOnError) == 'string' && val.focusOnError == 't') {
                //ValidatorSetFocus(val, event);
            }
        }
    }
    ValidatorUpdateDisplay(val);
};

SetValidatorCallouts = function () {
    var i;
    var pageValid = true;
    var isValidatorOnChange = document.getElementById('form1').hasAttribute('isValidatorOnChange');

    for (i = 0; i < Page_Validators.length; i++) {
        var inputControl = document.getElementById(Page_Validators[i].controltovalidate);
        var secondinputControl = document.getElementById(Page_Validators[i].secondcontroltovalidate);
        var validatorControl = document.getElementById(Page_Validators[i].id);

        var labelFor = document.querySelectorAll('[for="' + inputControl.id.substring(inputControl.id.lastIndexOf('_') + 1, inputControl.id.length) + '"]')
        if (!Page_Validators[i].isvalid) {
            if (inputControl != null) {
                WebForm_AppendToClassName(inputControl, 'err');
                if (inputControl.className.indexOf('select') > -1) {
                    var selectricDdl = inputControl.parentElement.parentElement.getElementsByClassName("selectric")[0];
                    WebForm_AppendToClassName(selectricDdl, 'err');
                    if (pageValid && !isValidatorOnChange) {
                        if (labelFor != null && labelFor.length > 0)
                            labelFor[0].scrollIntoView();
                        else
                            selectricDdl.scrollIntoView();
                        document.getElementById('form1').removeAttribute('isValidatorOnChange');
                    }
                }
                else if (pageValid && !isValidatorOnChange) {
                    if (labelFor != null && labelFor.length > 0)
                        labelFor[0].scrollIntoView();
                    inputControl.focus();
                    document.getElementById('form1').removeAttribute('isValidatorOnChange');
                }

            }

            if (secondinputControl != null) WebForm_AppendToClassName(secondinputControl, 'err');
            pageValid = false;
        }
    }
    document.getElementById('form1').removeAttribute('isValidatorOnChange');
    return pageValid;
};

ClearValidatorCallouts = function () {
    var i;
    var invalidConrols = [];
    for (i = 0; i < Page_Validators.length; i++) {
        var inputControl = document.getElementById(Page_Validators[i].controltovalidate);
        var secondinputControl = document.getElementById(Page_Validators[i].secondcontroltovalidate);
        var validatorControl = document.getElementById(Page_Validators[i].id);
        if (inputControl != null) {
            WebForm_RemoveClassName(inputControl, 'err');
            if (inputControl.className.indexOf('select') > -1) {
                var selectricDdl = inputControl.parentElement.parentElement.getElementsByClassName("selectric")[0];
                WebForm_RemoveClassName(selectricDdl, 'err');
            }
        }
        if (secondinputControl != null) WebForm_RemoveClassName(secondinputControl, 'err');
    }
};

ValidatorOnChange = function (event) {
    if (document.getElementById('form1') != null)
        document.getElementById('form1').setAttribute('isValidatorOnChange', 'true');

    if (!event) {
        event = window.event;
    }
    Page_InvalidControlToBeFocused = null;
    var targetedControl;
    if ((typeof (event.srcElement) != "undefined") && (event.srcElement != null)) {
        targetedControl = event.srcElement;
    }
    else {
        targetedControl = event.target;
    }
    var vals;

    if (typeof (targetedControl.Validators) != "undefined") {
        vals = targetedControl.Validators;
        // alert('here - 1');
    }
    else {
        if (targetedControl.tagName.toLowerCase() == "label") {
            targetedControl = document.getElementById(targetedControl.htmlFor);
            vals = targetedControl.Validators;
        }
    }
    var i;

    //if date picker caused it in IE...which can't find the textbox to get the list of validators for the control, so revalidate whole page
    if (vals == null)
        vals = Page_Validators;

    for (i = 0; i < vals.length; i++) {
        ValidatorValidate(vals[i], null, event);
    }

    ValidatorUpdateIsValid();
};

ValidatorUpdateDisplay = function (val) {
    if (typeof (val.display) == "string") {

        if (val.display == "None") {
            return;
        }
        if (val.display == "Dynamic") {
            //changed this block to not set display to inline, but to remove style attribute entirely
            if (val.isvalid)
                val.style.display = "none"; 
            else
                val.removeAttribute("style");
            return;
        }
    }
    if ((navigator.userAgent.indexOf("Mac") > -1) && (navigator.userAgent.indexOf("MSIE") > -1)) {
        val.style.display = "inline";
    }
    val.style.visibility = val.isvalid ? "hidden" : "visible";
};

var ValidationSummaryOnSubmitOrig = ValidationSummaryOnSubmit;
var ValidationSummaryOnSubmit = function () {
    var scrollToOrig = window.scrollTo;
    window.scrollTo = function () { };
    var retVal = ValidationSummaryOnSubmitOrig();
    window.scrollTo = scrollToOrig;
    return retVal;
}

CheckFormatOnly = function () {
    var result = true;

    if (typeof (Page_Validators) == "undefined") {
        return true;
    }

    var i;

    for (i = 0; i < Page_Validators.length; i++) {
        if ((Page_Validators[i].enabled == undefined || Page_Validators[i].enabled) &&
            (Page_Validators[i].evaluationfunction != RequiredFieldValidatorEvaluateIsValid)) {
            ValidatorValidate(Page_Validators[i]);

            if (!Page_Validators[i].isvalid) {
                result = false;
            }
        } else {
            Page_Validators[i].isvalid = true;
        }
    }

        if (result === false) {
            ValidationSummaryOnSubmit();
        }

    return result;
};

//clear validator errors
Page_ClientValidateReset = function() {
    if (typeof (Page_Validators) != "undefined") {
        for (var i = 0; i < Page_Validators.length; i++) {
            var validator = Page_Validators[i];
            validator.isvalid = true;
            ValidatorUpdateDisplay(validator);
        }
    }

    if (typeof (Page_ValidationSummaries) == "undefined")
        return;
    for (var i = 0; i < Page_ValidationSummaries.length; i++)
        Page_ValidationSummaries[i].style.display = "none";
};
