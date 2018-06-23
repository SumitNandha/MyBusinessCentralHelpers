codeunit 50100 "Zoom Management"
{
    trigger OnRun();
    begin
    end;

    procedure ZoomIn(RecordVariant : Variant);
    var
        DataTypeMgt : Codeunit "Data Type Management";
        RecReference : RecordRef;
        FieldReference: FieldRef;
        PKValue : Text[250];
        Index : Integer;
        ZoomLine : Record "Zoom Line" temporary;
    begin
        
        DataTypeMgt.GetRecordRef(RecordVariant, RecReference);
        PKValue := GetPrimaryKeyValue(RecReference);
        
        FOR Index := 1 TO RecReference.FieldCount DO BEGIN
            Clear(FieldReference);
            FieldReference := RecReference.FieldIndex(Index);

            ZoomLine.Init;
            ZoomLine."PK Value" := PKValue;
            ZoomLine."Source Table" := StrSubstNo('%1 (%2)', RecReference.Name, RecReference.Number);
            ZoomLine."Field No." := FieldReference.Number;
            ZoomLine."Field Name" := FieldReference.Name;
            ZoomLine."Field Value" := Format(FieldReference.Value);
            ZoomLine.Insert;
        END;

        ZoomLine.FindSet; // Go back to the top of the list
        Page.Run(Page::Zoom, ZoomLine);
    end;

    local procedure GetPrimaryKeyValue(RecReference: RecordRef) : Text[250];
    var
        KeyReference : KeyRef;
        FieldReference: FieldRef;
        Index : Integer;
        PKValue : Text[250];
    begin
        KeyReference := RecReference.KeyIndex(1);

        FOR Index := 1 TO KeyReference.FieldCount DO BEGIN
            Clear(FieldReference);
            FieldReference := KeyReference.FieldIndex(Index);
            PKValue += StrSubstNo('%1 ,', FieldReference.Value);
        END;

        PKValue := CopyStr(PKValue, 1, StrLen(PKValue) -1);
        exit(PKValue);
    end;

    // Event Subscribers

    [EventSubscriber(ObjectType::Page, 22, 'OnAfterActionEvent', 'Zoom In', false, false)]
    local procedure ZoomIn_OnAfterAction_CustomerList(var Rec : Record Customer);
    begin
        ZoomIn(Rec);
    end;
    [EventSubscriber(ObjectType::Page, 27, 'OnAfterActionEvent', 'Zoom In', false, false)]
    local procedure ZoomIn_OnAfterAction_VendorList(var Rec : Record Vendor);
    begin
        ZoomIn(Rec);
    end;
}