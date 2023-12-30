<%@ Page Title="" Language="C#" MasterPageFile="~/Site2.Master" AutoEventWireup="true" CodeBehind="Upload.aspx.cs" Inherits="prjPhysioImageEditor.Admin.Upload" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
 
    <div class="container mt-5">
        <fieldset class="scheduler-border">
            <legend class="form-label">Upload Body Parts Images</legend>
             <div class="form-group">
            <label class="form-label">File Name *</label>
            <asp:TextBox runat="server" ID="txtFileName" CssClass="form-control"></asp:TextBox>
            <asp:RequiredFieldValidator ClientIDMode="Static" runat="server" ID="fileNameValidator" ControlToValidate="txtFileName" CssClass="text-danger" ErrorMessage="File name is required."></asp:RequiredFieldValidator>
        </div>
        <div class="form-group">
            <label class="form-label">Description</label>
            <asp:TextBox runat="server" CssClass="form-control" ID="txtDescription" Rows="3" TextMode="MultiLine"></asp:TextBox>            
        </div>
            <div class="form-group">
            <label class="form-label">Status</label>
            <asp:CheckBox runat="server" ID="chkStatus" />
        </div>
        <div class="form-group mt-2">
            <asp:FileUpload ID="fileUpload" runat="server" class="form-control-file" />
            <br />
            <asp:RequiredFieldValidator runat="server" ID="fileUploadValidator" CssClass="text-danger" ErrorMessage="Please select file to upload" ControlToValidate="fileUpload"></asp:RequiredFieldValidator>
        </div>
           <div class="form-group mt-2"> 
             <asp:Button ID="uploadButton" runat="server" Text="Upload" OnClick="UploadButton_Click" CssClass="btn btn-sm btn-primary" />
             <a href="Index.aspx" class="btn btn-sm btn-warning">Back To List</a>
        </div>
        </fieldset>
    </div>
</asp:Content>
