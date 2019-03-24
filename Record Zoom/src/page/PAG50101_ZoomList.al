page 50101 "Zoom"
{
    PageType = List;
    SourceTable = "Zoom Line";
    Editable = false;

    layout
    {
        area(content)
        {
            group("Page Information")
            {
                field("PK Value"; "PK Value")
                {
                    ApplicationArea = All;
                }
                field("Source Table"; "Source Table")
                {
                    ApplicationArea = All;
                }
            }

            repeater(Group)
            {
                field("Field No."; "Field No.")
                {
                    ApplicationArea = All;
                }
                field("Field Name"; "Field Name")
                {
                    ApplicationArea = All;
                }
                field("Field Value"; "Field Value")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}