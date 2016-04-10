using System;
using System.Collections.Generic;
using System.IO;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Account_BuyCredits : System.Web.UI.Page
{
    DB_Helper db = new DB_Helper();

    public double total = 49;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["success_text"] != null)
        {
            lblResult.Text = Session["success_text"].ToString();
            lblResult.Visible = true;
            pnlMessage.Visible = true;
            divForm.Visible = false;
            Session["success_text"] = null;
            return;
        }

        if (MyUtils.MONTHLY_CHARGE_PLAN && MyUtils.SUBSCRIPTION_ACTIVE)
        {
            Response.Redirect("/Account/");
            return;
        }


        benefits_male.Visible = !MyUtils.MONTHLY_CHARGE_PLAN;
        benefits_female.Visible = MyUtils.MONTHLY_CHARGE_PLAN;
        PRICING.Visible = MyUtils.MONTHLY_CHARGE_PLAN;

        if (MyUtils.MONTHLY_CHARGE_PLAN) total = MyUtils.MonthlyFee;

        packages.Visible = MyUtils.IsMale;

        Page.Form.Attributes["data-form"] = "membership";

        //customer_profile_id=39889377
        //payment_profile_id=36190402
        if (payment_profile_id > 0 && customer_profile_id > 0)
        {
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

        if (MyUtils.MONTHLY_CHARGE_PLAN) amount = MyUtils.MonthlyFee;
        else GetPackageAmounts(ref amount, ref credits);

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
            CreditCardForm.SetCustomerInfo(paym);
        }

        string description = "Credit package " + credits;
        if (MyUtils.MONTHLY_CHARGE_PLAN) description = "Monthly Service Plan";

        string response = paym.Pay(paym.customer, (decimal)amount, description);
        isPaymSuccess = (response == "OK");


        if (isPaymSuccess)
        {
            if (MyUtils.MONTHLY_CHARGE_PLAN)
            {
                SetupBillingAndUpgradeMembership(amount);
                lblResult.Text = string.Format("Your card was charged {0} and your account was upgraded to VIP membership.", amount.ToString("c"));
            }
            else
            {
                BuyCreditsDB(amount, credits, MyUtils.ID_USER);
                lblResult.Text = string.Format("Your card was charged {0} and {1} credits were added to your account.", amount.ToString("c"), credits);
            }

            divForm.Visible = false;

            Session["success_text"] = lblResult.Text;
            Response.Redirect("/Account/Upgrade?ok=1");
            return;
        }
        else
        {
            lblResult.Text = "Your card was not charged. ERROR: " + paym.error;
            heading.Attributes["style"] = "background-color:#c00";
        }

        pnlMessage.Visible = true;
    }

    private int GetPackageAmounts(ref double amount, ref int credits)
    {
        int packageType;
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

        return packageType;
    }

    public void BuyCreditsDB(double amount_money, int credits, int id_user)
    {
        DB_Helper db = new DB_Helper();
        db.Execute("exec BUY_CREDITS " + id_user + "," + amount_money + "," + credits);
        List<string> p = new List<string>();
        p.Add("emailtitle:Credits were added");
        p.Add("line:We added " + credits + " credits to your account.");
        p.Add("credits:" + credits);
        p.Add("cost:" + amount_money.ToString("c2"));
        p.Add("date:" + DateTime.Now.ToString("MM/dd/yyyy"));
        p.Add("package:" + credits + " credit package");
        RWorker.AddToEmailQueue("EMAIL_PAYMENT", MyUtils.ID_USER, null, false, p);
        
        MyUtils.RefreshUserRow();
    }

    private void SetupBillingAndUpgradeMembership(double amount)
    {
        db.Execute("update users set membership='VIP',SUBSCRIPTION_ACTIVE=1,CANCEL_FROM_NEXT_PERIOD=null,NextPaymentDate=CONVERT(DATE, dateadd(month,1,getdate()), 101),UnsuccessfullCount=0,Rate=" + MyUtils.MonthlyFee.ToString() + ",NextBillingCycle=CONVERT(DATE, dateadd(month,1,getdate()), 101),LastPaymentDate=CONVERT(DATE, getdate(), 101) where id_user=" + MyUtils.ID_USER);
        
        List<string> p = new List<string>();
        p.Add("emailtitle:Your membership has been upgraded");
        p.Add("line:Your membership has been upgraded to VIP.");
        p.Add("cost:" + amount.ToString("c2"));
        p.Add("date:" + DateTime.Now.ToString("MM/dd/yyyy"));
        p.Add("package: Monthly Service");
        RWorker.AddToEmailQueue("EMAIL_PAYMENT", MyUtils.ID_USER, null, false, p);
        MyUtils.RefreshUserRow();
    }


}