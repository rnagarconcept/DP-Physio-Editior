<%@ Page Title="" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="prjPhysioImageEditor.Admin.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
   <div class="container-fluid mt-lg-5">
    <fieldset class="scheduler-border">
    <legend class="scheduler-border align-content-center">Login</legend>
        <div class="col-sm-6 offset-3 mt-5"> 
        <div class="form-group">
           <asp:Label runat="server" ID="lblMessage" CssClass="text-danger" Visible="false"></asp:Label>          
        </div>
        <div class="form-group">
            <label for="exampleInputEmail1">User Name</label>
            <asp:TextBox runat="server" CssClass="form-control" ID="txtUserName"></asp:TextBox>           
        </div>
        <div class="form-group">
            <label for="exampleInputPassword1">Password</label>
            <asp:TextBox runat="server" CssClass="form-control" ID="txtPassword" TextMode="Password"></asp:TextBox>           
        </div>
        <asp:Button Text="Login" runat="server" ID="btnLogin" CssClass="btn btn-primary mt-2" OnClick="btnLogin_Click" />      
    </div>
   </fieldset>
  </div> 
</asp:Content>
