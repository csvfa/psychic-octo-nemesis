class GuestDiscountRemovalLineItem < DiscountRemovalLineItem
  DESCRIPTION =             "Guest discount removed"
  NOTE =                    "Auto: Booking now has fewer than " + GuestDiscountLineItem::GUEST_NUMBER_THRESHOLD.to_s + " guests. "
end