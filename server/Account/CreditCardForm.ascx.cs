using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_CreditCardForm : System.Web.UI.UserControl
{
    public long payment_profile_id = 0;
    public long customer_profile_id = 0;

    public void LoadExistingProfile()
    {
        LoadIds();

        if (payment_profile_id > 0)
        {
            try
            {
                Payment.CustomerInfo c = Payment.GetMaskedProfile(customer_profile_id, payment_profile_id);
                this.txtFirstName.Text = c.firstname;
                txtLastName.Text = c.lastname;
                txtAddress.Text = c.bill_address;
                txtCity.Text = c.city;
                txtState.SelectedValue = c.state_code;
                ddlCountries.SelectedValue = c.country_code;
                txtZip.Text = c.zip;
                this.txtCard.Text = c.CC_number;
            }
            catch (Exception ex)
            {
                MyUtils.LogError(ex, "customer_profile_id=" + customer_profile_id + " payment_profile_id=" + payment_profile_id);
            }
        }

    }

    private void LoadIds()
    {
        object payment_profile_id_o = MyUtils.GetUserField("payment_profile_id");
        if (payment_profile_id_o != DBNull.Value)
        {
            payment_profile_id = Convert.ToInt64(payment_profile_id_o);
            customer_profile_id = Convert.ToInt64(MyUtils.GetUserField("customer_profile_id"));
        }
    }

    public void SetCustomerInfo(Payment paym)
    {
        LoadIds();
        if (paym.customer == null) paym.customer = new Payment.CustomerInfo();
        paym.customer.customer_profile_id = customer_profile_id;
        paym.customer.payment_profile_id = payment_profile_id;
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
    protected void Page_Load(object sender, EventArgs e)
    {
    }
}