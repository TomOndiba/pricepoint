<%@ Control Language="C#" AutoEventWireup="true" CodeFile="RegistrationCtrl.ascx.cs" Inherits="RegistrationCtrl" %>

<%@ Register Src ="~/Account/BirthdayCtrl.ascx" TagPrefix="uc" TagName="Birthday" %>

<div class="pure-g">
    <div class="pure-u-1 pure-u-lg-19-24">
        <!-- Form Register -->
        <div class="form form-register">
            <div class="info" runat="server">
                <asp:Label runat="server" ID="lblMessage"></asp:Label>
            </div>
            <div class="form-space">
                <h2 class="form-head" runat="server" id="h2Title">Create Your Profile</h2>
                <asp:ValidationSummary ID="RegisterUserValidationSummary" runat="server" CssClass="error" ValidationGroup="RegisterUserValidationGroup"/>
                <div class="form-line">
                    <div class="code">
                        <label class="form-label" for="zipCode">ZIP Code
                        <asp:RequiredFieldValidator ID="zipRequired" runat="server" ControlToValidate="zipCode" 
                                    CssClass="requiredValidator" ErrorMessage="ZIP Code is required." ToolTip="ZIP Code is required."  Display="Dynamic"
                                    ValidationGroup="RegisterUserValidationGroup">ZIP Code is required</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regexZipValid" runat="server" ValidationExpression="^[0-9]{5}(?:-[0-9]{4})?$"  Display="Dynamic"
                            CssClass="requiredValidator" ControlToValidate="zipCode"  ErrorMessage="Invalid Zip Format" ValidationGroup="RegisterUserValidationGroup">Invalid Zip Format</asp:RegularExpressionValidator>
                        </label>
                        <asp:TextBox runat="server" class="large form-code-input" id="zipCode" placeholder=""></asp:TextBox>
                        <span class="form-code-text">You must be able to go on a date in this city</span>
                    </div>
                </div>
                <div class="form-line">
                    <label class="form-label" for="profileHeadline">Profile headline
                         <asp:RequiredFieldValidator ID="profileHeadlineRequired" runat="server" ControlToValidate="profileHeadline" 
                            CssClass="requiredValidator" ErrorMessage="Profile headline is required." ToolTip="Profile headline is required."  Display="Dynamic"
                            ValidationGroup="RegisterUserValidationGroup">Profile headline is required</asp:RequiredFieldValidator>
                    </label>
                    <asp:TextBox runat="server" class="large" id="profileHeadline" placeholder=""></asp:TextBox>
                </div>
                <div class="form-line">
                    <label class="form-label" for="describe">Describe yourself
                    <asp:RequiredFieldValidator ID="describeRequired2" runat="server" ControlToValidate="describe" 
                                    CssClass="requiredValidator" ErrorMessage="Describe yourself is required." ToolTip="Describe yourself is required."  Display="Dynamic"
                                    ValidationGroup="RegisterUserValidationGroup">Describe yourself is required</asp:RequiredFieldValidator>
                    </label>
                    <asp:TextBox runat="server" class="large" id="describe" TextMode="MultiLine" Rows ="10" placeholder="I am very active, I love mountain biking, snowboarding, skydiving and shark feeding. James Bond is my mentor and The Most Interesting Man in the World is my life coach..."></asp:TextBox>
                </div>
                <div class="form-line">
                    <label class="form-label" for="ideal">What would be your ideal first date?
                        <asp:RequiredFieldValidator ID="rfvIdeal" runat="server" ControlToValidate="ideal" 
                                    CssClass="requiredValidator" ErrorMessage="What would be your ideal first date? - is required." ToolTip="What would be your ideal first date? - is required."  Display="Dynamic"
                                    ValidationGroup="RegisterUserValidationGroup">What would be your ideal first date? - is required</asp:RequiredFieldValidator>
                    </label>
                    <asp:TextBox runat="server" class="large" id="ideal"  TextMode="MultiLine" Rows ="10" placeholder="A lounge, bar or upscale restaurant, interesting conversation over a glass of wine, laughs and great chemistry."></asp:TextBox>
                </div>
                <section class="info">
                    <h2 class="title">Personal Information</h2>
                    <div class="pure-g">
                        <div class="pure-u-1 pure-u-sm-1-2 pure-u-md-1-3">
                            <div class="form-line">
                                <label class="form-label" for="ddlEthnicity" runat="server" id="lblEthnicity">Ethnicity
                                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="ddlEthnicity" 
                                        CssClass="requiredValidator" ErrorMessage="Ethnicity is required." ToolTip="Ethnicity is required." Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Ethnicity is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlEthnicity"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlReligion">Religion
                                    <asp:RequiredFieldValidator ID="rfvReligion" runat="server" ControlToValidate="ddlReligion" 
                                        CssClass="requiredValidator" ErrorMessage="Religion is required." ToolTip="Religion is required." Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Religion is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlReligion"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlChildren">Children
                                    <asp:RequiredFieldValidator ID="rfvChildren" runat="server" ControlToValidate="ddlChildren" 
                                        CssClass="requiredValidator" ErrorMessage="Children is required." ToolTip="Children is required." Display="Dynamic" 
                                        ValidationGroup="RegisterUserValidationGroup">Children is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlChildren"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlDrinking">Drinking Habits
                                    <asp:RequiredFieldValidator ID="rfvDrinking" runat="server" ControlToValidate="ddlDrinking" 
                                        CssClass="requiredValidator" ErrorMessage="Drinking Habits is required." ToolTip="Drinking Habits is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Drinking Habits is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlDrinking"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlSmoking">Smoking Habits
                                    <asp:RequiredFieldValidator ID="rfvSmoking" runat="server" ControlToValidate="ddlSmoking" 
                                        CssClass="requiredValidator" ErrorMessage="Smoking Habits is required." ToolTip="Smoking Habits is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Smoking Habits is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlSmoking"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="pure-u-1 pure-u-sm-1-2 pure-u-md-1-3 pure-u-mobile-hidden">&nbsp;</div>
                        <div class="pure-u-1 pure-u-sm-1-2 pure-u-md-1-3">
                            <div class="form-line">
                                <label class="form-label" for="ddlHeight">Height
                                    <asp:RequiredFieldValidator ID="rfvHeight" runat="server" ControlToValidate="ddlHeight" 
                                        CssClass="requiredValidator" ErrorMessage="Height is required." ToolTip="Height is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Height is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlHeight"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlBodyType">Body Type
                                    <asp:RequiredFieldValidator ID="rfvBodyType" runat="server" ControlToValidate="ddlBodyType" 
                                        CssClass="requiredValidator" ErrorMessage="Body Type is required." ToolTip="Body Type is required." Display="Dynamic" 
                                        ValidationGroup="RegisterUserValidationGroup">Body Type is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlBodyType"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlEyeColor">Eye Color
                                    <asp:RequiredFieldValidator ID="rfvEyeColor" runat="server" ControlToValidate="ddlEyeColor" 
                                        CssClass="requiredValidator" ErrorMessage="Eye Color is required." ToolTip="Eye Color is required." Display="Dynamic" 
                                        ValidationGroup="RegisterUserValidationGroup">Eye Color is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlEyeColor"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlHairColor">Hair Color
                                    <asp:RequiredFieldValidator ID="rfvHairColor" runat="server" ControlToValidate="ddlHairColor" 
                                        CssClass="requiredValidator" ErrorMessage="Hair Color is required." ToolTip="Hair Color is required." Display="Dynamic" 
                                        ValidationGroup="RegisterUserValidationGroup">Hair Color is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                     <asp:DropDownList CssClass="select" runat="server" id="ddlHairColor"></asp:DropDownList>
                                </div>
                            </div>
                            <div class="form-line">
                                <label class="form-label" for="ddlRelationship">Relationship Status
                                    <asp:RequiredFieldValidator ID="rfvRelationship" runat="server" ControlToValidate="ddlRelationship" 
                                        CssClass="requiredValidator" ErrorMessage="Relationship Status is required." ToolTip="Relationship Status is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Relationship Status is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlRelationship"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="pure-u-1">
                            <uc:Birthday ID="birthday" runat="server"/>
                        </div>
                        <div class="pure-u-1">
                            <div class="form-line">
                                <label class="form-label" for="ocupation">Ocupation
                                    <asp:RequiredFieldValidator ID="rvfOcupation" runat="server" ControlToValidate="ocupation" 
                                        CssClass="requiredValidator" ErrorMessage="Ocupation is required." ToolTip="Ocupation is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Ocupation is required</asp:RequiredFieldValidator>
                                </label>
                                <asp:TextBox runat="server" class="large" id="ocupation"></asp:TextBox>
                            </div>
                        </div>
                        <div class="pure-u-1 pure-u-sm-1-2 pure-u-md-1-3">
                            <div class="form-line">
                                <label class="form-label" for="ddlEducation">Education
                                    <asp:RequiredFieldValidator ID="rfvEducation" runat="server" ControlToValidate="ddlEducation" 
                                        CssClass="requiredValidator" ErrorMessage="Education is required." ToolTip="Education is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Education is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlEducation"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="pure-u-1 pure-u-sm-1-2 pure-u-md-1-3">
                            <div class="form-line">
                                <label class="form-label" for="ddlIncome">Annual Income
                                    <asp:RequiredFieldValidator ID="rfvIncome" runat="server" ControlToValidate="ddlIncome" 
                                        CssClass="requiredValidator" ErrorMessage="Annual Income is required." ToolTip="Annual Income is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Annual Income is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlIncome"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                        <div class="pure-u-1 pure-u-sm-1-2 pure-u-md-1-3">
                            <div class="form-line">
                                <label class="form-label" for="ddlWorth">Net Worth
                                    <asp:RequiredFieldValidator ID="rfvWorth" runat="server" ControlToValidate="ddlWorth" 
                                        CssClass="requiredValidator" ErrorMessage="Net Worth is required." ToolTip="Net Worth is required."  Display="Dynamic"
                                        ValidationGroup="RegisterUserValidationGroup">Net Worth is required</asp:RequiredFieldValidator>
                                </label>
                                <div class="select-small">
                                    <asp:DropDownList CssClass="select" runat="server" id="ddlWorth"></asp:DropDownList>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section>
                    <h2 class="title">What Are You Looking For?</h2>
                    <div class="form-line form-line-checkbox">
                        <asp:CheckBox runat="server" ID="cbxShortDating" class="css-checkbox" Text="Short Term Dating" ></asp:CheckBox>
                    </div>
                    <div class="form-line form-line-checkbox">
                        <asp:CheckBox runat="server" ID ="cbxFriendship" class="css-checkbox" Text="Friendship - Activity Partner" ></asp:CheckBox>
                    </div>
                    <div class="form-line form-line-checkbox">
                        <asp:CheckBox runat="server" ID ="cbxLongTerm" class="css-checkbox" Text ="Long Term - Possibly Marriage"></asp:CheckBox>
                    </div>
                    <div class="form-line form-line-checkbox">
                        <asp:CheckBox runat="server" ID ="cbxMutually" class="css-checkbox" Text ="Mutually Beneficial Arangement" ></asp:CheckBox>
                    </div>
                    <div class="form-line form-line-checkbox">
                        <asp:CheckBox runat="server" ID ="cbxDiscreet" class="css-checkbox" Text ="Discreet Affair"></asp:CheckBox>
                    </div>
                    <div class="form-line form-line-checkbox">
                        <asp:CheckBox runat="server" ID ="cbxCasual" class="css-checkbox" Text ="Casual Dating - No Strings Atached"></asp:CheckBox>
                    </div>
                </section>

                <div class="form-submit">
                    <asp:Button runat="server" CcsClass="button button-inline" ID="btnCompleteProfile" Text="Complete Profile" OnClick ="btnCompleteProfile_Click" ValidationGroup="RegisterUserValidationGroup"/>
                </div>
            </div>
        </div>
        

    </div>
</div>

