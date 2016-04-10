using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_UpdateBilling : System.Web.UI.Page
{

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!this.IsPostBack)
        {
            CreditCardForm.LoadExistingProfile();
            CreditCardForm.Visible = CreditCardForm.payment_profile_id > 0;
        }
    }

    protected void btnSubmit_Click(object sender, EventArgs e)
    {
        
        Payment pay = new Payment();
        CreditCardForm.SetCustomerInfo(pay);
        Payment.CustomerInfo customer = pay.customer;
        if (customer.customer_profile_id != 0)
        {
            try
            {
                customer.payment_profile_id = pay.SetCustomerPaymentProfile(customer.customer_profile_id);
                lblResult.Text = "Thank you, your credit card info has been updated.";
                CreditCardForm.Visible = false;
                mainsection.Visible = false;
            }
            catch (System.Exception ex)
            {
                lblResult.Style["color"] = "white";
                lblResult.Text = "ERROR: We are sorry, our payment processor is down, please try again in a few minutes. Error=" + ex.Message;
                heading.Attributes["style"] = "background-color:#c00";
                MyUtils.LogError(ex);
            }
        }

    }
}