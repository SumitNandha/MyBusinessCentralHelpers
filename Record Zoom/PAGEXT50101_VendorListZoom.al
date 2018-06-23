pageextension 50101 "Vendor List Zoom" extends "Vendor List"
{
    actions
    {
        addlast(Processing)
        {
            action("Zoom In")
            {
                CaptionML = ENG='Show All Fields',
                            ENU='Show All Fields';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Database;
            }
        }
    }
}