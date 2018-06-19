codeunit 50100 "Email Invoice As PDF Method"
{
    trigger OnRun();
    var
        SalesInvoiceHeader : Record "Sales Invoice Header";
    begin

        // This is a demo to send an invoice from Cronus
        if not Confirm('Ready?', true) then
            exit;
        
        SalesInvoiceHeader.SetRange("No.", '103018');
        SalesInvoiceHeader.FindFirst;
        EmailInvoiceAsPDF(SalesInvoiceHeader, 'marcell.turi@outlook.com');
        Message('Finished.');
    end;

    var
        TxtEmailSubject : TextConst ENG='%1 - Invoice - %2', ENU='%1 - Invoice - %2';
        TxtAttachmentName : TextConst ENG='Invoice - %1.pdf', ENU='Invoice - %1.pdf';
        TxtCouldNotSaveReport : TextConst ENG='Could not save report, Report Id %1.', ENU='Could not save report, Report Id %1.';
        TxtTableNotSupported : TextConst ENG='%1 not supported.', ENU='%1 not supported.';

    procedure EmailInvoiceAsPDF(var SalesInvoiceHeader : Record "Sales Invoice Header"; ToAddress : Text);
    begin
        OnBeforeEmailInvoiceAsPDF(SalesInvoiceHeader, ToAddress);
        DoEmailInvoiceAsPDF(SalesInvoiceHeader, ToAddress);
        OnAfterEmailInvoiceAsPDF(SalesInvoiceHeader, ToAddress);
    end;

    local procedure DoEmailInvoiceAsPDF(var SalesInvoiceHeader : Record "Sales Invoice Header"; ToAddress : Text);
    var
        SMTPMail : Codeunit "SMTP Mail";
        TempBlob : Record TempBlob temporary;
        VarInStream : InStream;
        CompanyInformation : Record "Company Information";
        EmailSubject : Text;
        AttachmentName : Text;
    begin
        CompanyInformation.Get;

        EmailSubject := StrSubstNo(TxtEmailSubject, CompanyInformation.Name, SalesInvoiceHeader."No.");
        AttachmentName := StrSubstNo(TxtAttachmentName, SalesInvoiceHeader."No.");
        
        SMTPMail.CreateMessage(CompanyInformation.Name, CompanyInformation."E-Mail", ToAddress, EmailSubject, '', true);
        
        SaveDocumentAsPDFToStream(SalesInvoiceHeader, TempBlob);
        TempBlob.Blob.CreateInStream(VarInStream);
        SMTPMail.AddAttachmentStream(VarInStream, AttachmentName);
        
        SMTPMail.Send;
    end;

    local procedure SaveDocumentAsPDFToStream(DocumentVariant : Variant; var TempBlob : Record TempBlob temporary) : Boolean;
    var
        DataTypeMgt : Codeunit "Data Type Management";
        ReportID : Integer;
        VarOutStream : OutStream;
        DocumentRef : RecordRef;
    begin    
        ReportID := GetDocumentReportID(DocumentVariant);
        DataTypeMgt.GetRecordRef(DocumentVariant, DocumentRef);

        TempBlob.Blob.CreateOutStream(VarOutStream);
        if Report.SaveAs(ReportID, '', ReportFormat::Pdf, VarOutStream, DocumentRef) then
            exit(true)
        else
            Error(TxtCouldNotSaveReport, ReportID);
    end;
    
    local procedure GetDocumentReportID(DocumentVariant: Variant) : Integer;
    var
        DataTypeMgt : Codeunit "Data Type Management";
        DocumentRef : RecordRef;
        ReportSelection : Record "Report Selections";
    begin
        DataTypeMgt.GetRecordRef(DocumentVariant, DocumentRef);

        case DocumentRef.Number of
            Database::"Sales Invoice Header": 
                ReportSelection.SetRange(Usage, ReportSelection.Usage::"S.Invoice");
            else
                error(TxtTableNotSupported, DocumentRef.Name);
        end;

        if ReportSelection.FindFirst then
            exit(ReportSelection."Report ID");

    end;

    [IntegrationEvent(false,false)]
    local procedure OnBeforeEmailInvoiceAsPDF(var SalesInvoiceHeader : Record "Sales Invoice Header"; ToAddress : Text);
    begin
    end;

    [IntegrationEvent(false,false)]
    local procedure OnAfterEmailInvoiceAsPDF(var SalesInvoiceHeader : Record "Sales Invoice Header"; ToAddress : Text);
    begin
    end;
}