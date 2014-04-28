class EarlyBirdDiscountRemovalLineItem < DiscountRemovalLineItem
  DESCRIPTION =             "Early bird offer removed"
  NOTE =                    "Auto: Booking now has fewer than " + EarlyBirdDiscountLineItem::EARLY_BIRD_OFFER_GUEST_NUMBER_THRESHOLD.to_s + " guests. "
end