using RobsCommonUtils;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class RegistrationCtrl : System.Web.UI.UserControl
{
    DB_Helper db = new DB_Helper();
    public bool IsRegistration { get; set; }

    void BindLookupDropdown(string type, DropDownList l)
    {
        DataSet d = db.GetDataSetCache("select id_lookup,text from lookups where type='" + type + "'");
        l.DataTextField = "text";
        l.DataValueField = "id_lookup";
        l.DataSource = d;
        l.DataBind();
        l.Items.Insert(0, "");
    }

    public int ID_USER
    {
        get
        {
            int id = MyUtils.ID_USER;
            if (MyUtils.IsUserAdmin() && Request.QueryString["id"] != null) id = Convert.ToInt32(Request.QueryString["id"]);
            return id;
        }
    }

    protected void Page_Init(object sender, EventArgs e)
    {

        if (IsRegistration)
        {
            h2Title.InnerText = "Create Your Profile";
            btnCompleteProfile.Text = "Create My Profile";
        }
        else
        {
            h2Title.InnerText = "Update Your Profile";
            btnCompleteProfile.Text = "Update Profile";
        }

        #region Set DropDownLists

        BindLookupDropdown("Ethnicity", ddlEthnicity);
        BindLookupDropdown("Religion", ddlReligion);
        BindLookupDropdown("Children", ddlChildren);
        BindLookupDropdown("Drinking Habit", ddlDrinking);
        BindLookupDropdown("Smoking Habit", ddlSmoking);
        BindLookupDropdown("Height", ddlHeight);
        BindLookupDropdown("Body Type", ddlBodyType);
        BindLookupDropdown("Eye Color", ddlEyeColor);
        BindLookupDropdown("Hair Color", ddlHairColor);
        BindLookupDropdown("Relationship Status", ddlRelationship);
        BindLookupDropdown("Education", ddlEducation);
        BindLookupDropdown("Income", ddlIncome);
        BindLookupDropdown("Net Worth", ddlWorth);

        birthday.IsRegistration = IsRegistration;
        #endregion

        #region GetUserData from DB

        DataRow userRow = db.GetRow(string.Format("select * from users where id_user={0}", ID_USER));

        profileHeadline.Text = userRow["title"].ToString();
        describe.Text = userRow["description"].ToString();
        ideal.Text = userRow["firstdate"].ToString();
        zipCode.Text = userRow["zip"].ToString();

        //ddl
        ddlEthnicity.SelectedValue = Utils.GetDdlField(userRow, "id_ethnicity");
        ddlReligion.SelectedValue = Utils.GetDdlField(userRow, "id_religion");
        ddlChildren.SelectedValue = Utils.GetDdlField(userRow, "id_children");
        ddlDrinking.SelectedValue = Utils.GetDdlField(userRow, "id_drinking");
        ddlSmoking.SelectedValue = Utils.GetDdlField(userRow, "id_smoking");
        ddlHeight.SelectedValue = Utils.GetDdlField(userRow, "id_height");
        ddlBodyType.SelectedValue = Utils.GetDdlField(userRow, "id_bodytype");
        ddlEyeColor.SelectedValue = Utils.GetDdlField(userRow, "id_eyecolor");
        ddlHairColor.SelectedValue = Utils.GetDdlField(userRow, "id_haircolor");
        ddlRelationship.SelectedValue = Utils.GetDdlField(userRow, "id_relationship");
        ddlEducation.SelectedValue = Utils.GetDdlField(userRow, "id_education");
        ddlIncome.SelectedValue = Utils.GetDdlField(userRow, "id_income");
        ddlWorth.SelectedValue = Utils.GetDdlField(userRow, "id_networth");

        birthday.SetBirthday((DateTime)userRow["birthdate"]);

        ocupation.Text = userRow["occupation"].ToString();

        //cbx
        cbxShortDating.Checked = Utils.GetBoolField(userRow, "lookingforshortterm");
        cbxFriendship.Checked = Utils.GetBoolField(userRow, "lookingforfriendship");
        cbxLongTerm.Checked = Utils.GetBoolField(userRow, "lookingforlongterm");
        cbxMutually.Checked = Utils.GetBoolField(userRow, "lookingforarrangement");
        cbxDiscreet.Checked = Utils.GetBoolField(userRow, "lookingforaffair");
        cbxCasual.Checked = Utils.GetBoolField(userRow, "lookingforcasualdating");
        #endregion
    }

    string title;
    string desc;
    string date;

    protected void btnCompleteProfile_Click(object sender, EventArgs e)
    {
        if (!cbxCasual.Checked && !cbxDiscreet.Checked && !cbxFriendship.Checked && !cbxLongTerm.Checked && !cbxMutually.Checked && !cbxShortDating.Checked)
        {
            MyUtils.DisplayCustomMessageInValidationSummary("You should select 'What Are You Loking For?'", RegisterUserValidationSummary, "RegisterUserValidationGroup");
            return;
        }

        title = MyUtils.StripHTML(profileHeadline.Text.Trim());
        desc = MyUtils.StripHTML(describe.Text.Trim());
        date = MyUtils.StripHTML(ideal.Text.Trim());

        nGram g = new nGram();
        string s = title + ". " + desc + ". " + date;
        double q;
        q = g.CalculateQuality(s);

        if (q < 0.11)
        {
            MyUtils.DisplayCustomMessageInValidationSummary("Your description is below our quality standards. Please use correct grammar and write in complete sentences.", RegisterUserValidationSummary, "RegisterUserValidationGroup");
            return;
        }

        if (g.WordCount < 5)
        {
            MyUtils.DisplayCustomMessageInValidationSummary("Your description doesn't have enough details. Please describe yourself in detail using correct grammar and complete sentences.", RegisterUserValidationSummary, "RegisterUserValidationGroup");
            return;
        }

        string xx;

        xx = Profanity.TestAndMessage(desc);
        if (xx != null)
        {
            MyUtils.DisplayCustomMessageInValidationSummary("Your description " + xx, RegisterUserValidationSummary, "RegisterUserValidationGroup");
            return;
        }
        xx = Profanity.TestAndMessage(title);
        if (xx != null)
        {
            MyUtils.DisplayCustomMessageInValidationSummary("Your title " + xx, RegisterUserValidationSummary, "RegisterUserValidationGroup");
            return;
        }
        xx = Profanity.TestAndMessage(date);
        if (xx != null)
        {
            MyUtils.DisplayCustomMessageInValidationSummary("Your ideal date description " + xx, RegisterUserValidationSummary, "RegisterUserValidationGroup");
            return;
        }

        desc = ReplaceEmail(desc);
        title = ReplaceEmail(title);
        date = ReplaceEmail(date);

        zip = MyUtils.StripHTML(zipCode.Text);
        otherZipData = MyUtils.GetZipCoordinates(zip.ToString());

        if (otherZipData == null)
        {
            MyUtils.DisplayCustomMessageInValidationSummary("ZIP code does not exist. Please enter valid zip code.", RegisterUserValidationSummary, "RegisterUserValidationGroup");
            return;
        }

        SaveUserInDB();
        MyUtils.RefreshUserRow();

        if (IsRegistration)
        {
            Session["message"] = "Your profile has been saved. Please upload photos.";
            Response.Redirect("~/Account/UploadPhotos?hidemenu=1");
        }
        else
        {
            Session["message"] = "Your profile has been updated";
            Response.Redirect(Utils.GetProfileLink(ID_USER));
        }
    }

    private string ReplaceEmail(string desc)
    {
        Regex emailReplace = new Regex(@"[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,6}", RegexOptions.IgnoreCase);
        desc = emailReplace.Replace(desc, "******@****.***");

        emailReplace = new Regex(@"[A-Z0-9.-]+\.(com|ru|co|org|io|net|info|cc|ws|name)\b", RegexOptions.IgnoreCase);
        desc = emailReplace.Replace(desc, "**********.***");
        return desc;
    }
    MyUtils.GeoInfo otherZipData;
    string zip;
    private void SaveUserInDB()
    {
       try
        {
            DataSet ds = db.CommandBuilder_LoadDataSet(string.Format("select * from users where id_user={0}", ID_USER));
            DataRow userRow = ds.Tables[0].Rows[0];


            userRow["zip"] = zip;
            userRow["latitude"] = otherZipData.lat;
            userRow["longitude"] = otherZipData.lon;
            userRow["place"] = otherZipData.place;

            string old_description = Convert.ToString(userRow["title"]) + Convert.ToString(userRow["description"]) + Convert.ToString(userRow["firstdate"]);

            userRow["title"] = title;
            userRow["description"] = desc;
            userRow["firstdate"] = date;

            string new_description = Convert.ToString(userRow["title"]) + Convert.ToString(userRow["description"]) + Convert.ToString(userRow["firstdate"]);

            if (old_description.ToUpper() != new_description.ToUpper()) userRow["status"] = 0;


            //ddl
            Utils.SetDdlField(ddlEthnicity, userRow, "id_ethnicity");
            Utils.SetDdlField(ddlReligion, userRow, "id_religion");
            Utils.SetDdlField(ddlChildren, userRow, "id_children");
            Utils.SetDdlField(ddlDrinking, userRow, "id_drinking");
            Utils.SetDdlField(ddlSmoking, userRow, "id_smoking");
            Utils.SetDdlField(ddlHeight, userRow, "id_height");
            Utils.SetDdlField(ddlBodyType, userRow, "id_bodytype");
            Utils.SetDdlField(ddlEyeColor, userRow, "id_eyecolor");
            Utils.SetDdlField(ddlHairColor, userRow, "id_haircolor");
            Utils.SetDdlField(ddlRelationship, userRow, "id_relationship");
            Utils.SetDdlField(ddlEducation, userRow, "id_education");
            Utils.SetDdlField(ddlIncome, userRow, "id_income");
            Utils.SetDdlField(ddlWorth, userRow, "id_networth");

            string error = "";
            DateTime dt = birthday.GetBirthday(out error);
            if (error != "")
            {
                MyUtils.DisplayCustomMessageInValidationSummary(error, RegisterUserValidationSummary);
                return;
            }
            userRow["birthdate"] = dt;
            userRow["occupation"] = MyUtils.StripHTML(ocupation.Text.Trim());

            //cbx
            userRow["lookingforshortterm"] = cbxShortDating.Checked;
            userRow["lookingforfriendship"] = cbxFriendship.Checked;
            userRow["lookingforlongterm"] = cbxLongTerm.Checked;
            userRow["lookingforarrangement"] = cbxMutually.Checked;
            userRow["lookingforaffair"] = cbxDiscreet.Checked;
            userRow["lookingforcasualdating"] = cbxCasual.Checked;

            db.CommandBuilder_SaveDataset();
        }
        finally
        {
            db.CommandBuilder_Disconnect();
        }


    }
}