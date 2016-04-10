using System;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_BuyCredits : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    protected void Page_Load(object sender, EventArgs e)
    {
        //btnSubmit.OnClientClick = ClientScript.GetPostBackEventReference(btnSubmit, "") + ";this.value='Submitting...';this.disabled=true;";

        Page.Form.Attributes["data-form"] = "membership";

        //customer_profile_id=39889377
        //payment_profile_id=36190402
        if (payment_profile_id > 0 && customer_profile_id > 0)
        {
            //get the profile
            //                Payment.CustomerInfo i= Payment.GetMaskedProfile(customer_profile_id, payment_profile_id);
            LAST_DIGITS = MyUtils.GetUserField("CC4DIGIT").ToString();
        }
    }

    Payment paym = new Payment();

    long customer_profile_id
    {
        get
        {
            object o = MyUtils.GetUserField("customer_profile_id");
            if (Convert.IsDBNull(o)) return 0;
            return Convert.ToInt64(o);
        }
    }

    long payment_profile_id
    {
        get
        {
            object o = MyUtils.GetUserField("payment_profile_id");
            if (Convert.IsDBNull(o)) return 0;
            return Convert.ToInt64(o);
        }
    }


    public string LAST_DIGITS;
    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        double amount = 0;
        int credits = 0;
        int packageType = 0;

        #region Get package type

        if (int.TryParse(hiddenPackage.Value, out packageType))
        {
            switch (packageType)
            {
                case 1:
                    amount = 49;
                    credits = 100;
                    break;
                case 2:
                    amount = 99;
                    credits = 450;
                    break;
                case 3:
                    amount = 199;
                    credits = 1000;
                    break;
                default:
                    amount = 49;
                    credits = 100;
                    break;
            }
        }
        #endregion

        bool isPaymSuccess = false;

        paym.customer = new Payment.CustomerInfo();
        paym.customer.id_user = MyUtils.ID_USER;

        if (hiddenCardSelect.Value == "1" && customer_profile_id > 0 && payment_profile_id > 0)
        {
            //use old card
            paym.customer.customer_profile_id = customer_profile_id;
            paym.customer.payment_profile_id = payment_profile_id;
        }
        else
        {
            paym.customer.CC_number = txtCard.Text;
            paym.customer.CC_exp_month = Convert.ToInt32(txtExpires.Text.Substring(0, 2));
            paym.customer.CC_exp_year = Convert.ToInt32(txtExpires.Text.Substring(3, 2));
            paym.customer.CC_csv = txtSecurityCode.Text;
            paym.customer.firstname = txtFirstName.Text;
            paym.customer.lastname = txtLastName.Text;
            paym.customer.bill_address = txtAddress.Text;
            paym.customer.city = txtCity.Text;
            paym.customer.state_code = txtState.Text;
            paym.customer.zip = txtZip.Text;
            paym.customer.country_code = ddlCountries.SelectedValue;
        }

        string response = paym.Pay(paym.customer, (decimal)amount, "Credit package " + credits);
        isPaymSuccess = (response == "OK");


        if (isPaymSuccess)
        {
            BuyCreditsDB(amount, credits, MyUtils.ID_USER);

            lblResult.Text = string.Format("Your card was charged ${0} and {1} credits were added to your account.", amount, credits);

            divForm.Visible = false;

        }
        else
        {
            lblResult.Text = "Your card was not charged. ERROR: " + paym.error;
            heading.Attributes["style"] ="background-color:#c00";
        }

        pnlMessage.Visible = true;
    }

    public void BuyCreditsDB(double amount_money, int credits, int id_user)
    {
        DB_Helper db = new DB_Helper();
        db.Execute("exec BUY_CREDITS " + id_user + "," + amount_money + "," + credits);

        MyUtils.RefreshUserRow();
    }
}