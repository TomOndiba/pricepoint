<%@ Page Title="Log In" Language="C#" MasterPageFile="~/MasterPage.master" AutoEventWireup="True" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<asp:Content ID="BodyContent" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <style type="text/css">
.container{padding: 0;}
</style>

	<!-- Index -->
	<div class="index">
		<div class="wrapper">
			<div class="space">
				<div class="cell">
					<h1 class="heading">Where Generous Men <br>Date Beautiful Women</h1>
					<p class="slogan">Men: Go on a date tonight <br>Women: Get paid to go out</p>
	
    					<div class="form-line">
							<label for="sex">I am</label>
							<div class="select-large">
								<select id="sex" name="sex" class="select" runat="server">
									<option value="man" selected>Generous man seeking beautiful women</option>
									<option value="woman">Attractive woman: get paid to go out</option>
								</select>
							</div>
                            <asp:Button ID="Button1" CssClass="button button-large" runat="server" OnClick="Button1_Click" Text="Join the Dating Auction" />
						</div>
					
				</div>
			</div>
		</div>
	</div>
	<!-- /Index -->


	<!-- Steps -->
	<section class="steps">
		<div class="wrapper">
			<h2 class="heading">How it Works</h2>
			<div class="area">
				<p class="info mobile-hidden">Set up a profile in just 2 minutes and find someone special in your area.</p>
				<div class="col">
					<a href="/Sign-Up?s=M"><img class="image" src="img/temp/man.jpg" alt=""></a>
					<p class="name">Generous Men</p>
					<div class="step">
						<span class="icon icon-join"></span>
						<p class="h">Join</p>
					</div>
					<div class="step">
						<span class="icon icon-offer"></span>
						<p class="h">Send Offers</p>
						<p class="text mobile-hidden">Find a gorgeous lady you'd like to date. Send her an offer.</p>
					</div>
				</div>
				<div class="col">
					<a href="/Sign-Up?s=F"><img class="image" src="img/temp/woman.jpg" alt=""></a>
					<p class="name">Gorgeous Ladies</p>
					<div class="step">
						<span class="icon icon-join"></span>
						<p class="h">Join</p>
					</div>
					<div class="step">
						<span class="icon icon-accept"></span>
						<p class="h">Accept Offers</p>
						<p class="text mobile-hidden">Accept offers from generous men in your area. Get paid on your first date.</p>
					</div>
				</div>
				<div class="col">
					<div class="step">
						<span class="icon icon-date"></span>
						<p class="h">Go on a date!<br />Generous man pays attractive lady for the first date</p>
						<p class="text mobile-hidden">Agree on when and where you want to meet. Enjoy your date!</p>
					</div>
				</div>
			</div>
		</div>
	</section>
	<!-- /Steps -->

	<!-- Article -->
		<div class="wrapper">
			<div class="space">
				<div class="cell" style="text-align:center">
					<h2 class="heading">No Escorts Allowed!</h2>
<p>We connect sucessful men with attractive women for the purpose of real connection.<br />
    Escorts are not welcome, members that engage in promoting illegal services will be banned.</p>
				</div>
			</div>
		</div>

	<!-- Article -->
	<article class="article article-brown">
		<div class="wrapper">
			<div class="space">
				<div class="cell">
					<h2 class="heading">Generous Men</h2>
					<p>Frustrated with online dating?</p>
					<p>Find attractive ladies, make offers and get a date tonight!</p>
					<p>Pay your date when you meet in person.</p>
				</div>
			</div>
		</div>
	</article>
	<!-- /Article -->


	<!-- Article -->
	<article class="article article-blue">
		<div class="wrapper">
			<div class="space">
				<div class="cell">
					<h2 class="heading">Gorgeous Ladies</h2>
					<p>Get paid to go out.</p>
					<p>Get offers from successful men in your area and get paid when you go on the first date.</p>
					<p>Our service is absolutely free for women.</p>
				</div>
			</div>
		</div>
	</article>
	<!-- /Article -->


	<!-- Call-To-Action -->
	<section class="call-to-action">
		<div class="wrapper">
			<h2 class="heading">Get a Date Tonight!</h2>
			<p>Traditional dating websites make it difficult to get a date. They operate under the assumption that 2 people have to know everything about each other before they can go out. Men have to jump through hoops to actually meet a woman in person.</p>
			<p>Successful men don't have time for games or lengthy interview style questions.</p>
			<p>PricePointDating.com is your dating shortcut! Send offers to gorgeous women and get a date tonight!</p>
			<a href="/sign-up" class="button button-large">Join the Dating Auction</a>
		</div>
	</section>
	<!-- /Call-To-Action -->



</asp:Content>
