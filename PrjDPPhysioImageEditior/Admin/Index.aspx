<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/Site2.Master" CodeBehind="Index.aspx.cs" Inherits="prjPhysioImageEditor.Admin.Index" %>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolder1">
    <div class="container-fluid">
        <fieldset class="scheduler-border">
            <legend class="scheduler-border align-content-center">Body Parts</legend>
            <asp:DataList ID="dataListItems" runat="server" RepeatDirection="Horizontal" Width="100%" RepeatLayout="Table" RepeatColumns="3" OnItemDataBound="dataListItems_ItemDataBound">
                <ItemTemplate>
                    <div class="card mt-0">
                        <asp:Image CssClass="card-img-top" ID="imageControl" runat="server" Style="margin:auto; width: 150px; height: 150px;" />
                        <div class="card-body text-center">
                            <h4 class="card-title" runat="server" id="h4Heading"></h4>                           
                            <p class="card-text" runat="server" id="pDescription"></p>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:DataList>
            <br />
            <a href="Upload.aspx" class="btn btn-sm btn-success">Upload</a>
        </fieldset>

    </div>
    <script>
        $(function () {
            $('.example-popover').popover({
                container: 'body'
            })
        })
    </script>
</asp:Content>


