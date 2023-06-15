package com.app.xtrahelpuser.CustomView;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.text.TextUtils;
import android.util.Pair;

import com.app.xtrahelpuser.Interface.CardTypeDetect;
import com.app.xtrahelpuser.R;

import org.jetbrains.annotations.NotNull;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map.Entry;

public enum CardType {
    /**
     * American Express cards start in 34 or 37
     */
    AMEX("AmEx"),
    /**
     * Diners Club
     */
    DINERSCLUB("DinersClub"),
    /**
     * Discover starts with 6x for some values of x.
     */
    DISCOVER("Discover"),
    /**
     * JCB (see http://www.jcbusa.com/) cards start with 35
     */
    JCB("JCB"),
    /**
     * Mastercard starts with 51-55
     */
    MASTERCARD("MasterCard"),
    /**
     * Visa starts with 4
     */
    VISA("Visa"),
    /**
     * Maestro
     */
    MAESTRO("Maestro"),

    UNION("Union"),
    /**
     * Unknown card type.
     */
    UNKNOWN("Unknown"),
    /**
     * Not enough information given.
     * <br><br>
     * More digits are required to know the card type. (e.g. all we have is a 3, so we don't know if
     * it's JCB or AmEx)
     */
    INSUFFICIENT_DIGITS("More digits required");

    public final String name;

    private static int minDigits = 1;

    private CardType(String name) {
        this.name = name;
    }

    @Override
    public String toString() {
        return name;
    }


//    public String getDisplayName(String languageOrLocale) {
//        switch (this) {
//            case AMEX:
//                return LocalizedStrings.getString(StringKey.CARDTYPE_AMERICANEXPRESS, languageOrLocale);
//            case DINERSCLUB:
//            case DISCOVER:
//                return LocalizedStrings.getString(StringKey.CARDTYPE_DISCOVER, languageOrLocale);
//            case JCB:
//                return LocalizedStrings.getString(StringKey.CARDTYPE_JCB, languageOrLocale);
//            case MASTERCARD:
//                return LocalizedStrings.getString(StringKey.CARDTYPE_MASTERCARD, languageOrLocale);
//            case MAESTRO:
//                return LocalizedStrings.getString(StringKey.CARDTYPE_MAESTRO, languageOrLocale);
//            case VISA:
//                return LocalizedStrings.getString(StringKey.CARDTYPE_VISA, languageOrLocale);
//            default:
//                break;
//        }
//
//        return null;
//    }

    /**
     * @return 15 for AmEx, -1 for unknown, 16 for others.
     */
    public int numberLength() {
        int result;
        switch (this) {
            case AMEX:
                result = 15;
                break;
            case JCB:
            case MASTERCARD:
            case MAESTRO:
            case VISA:
            case DISCOVER:
                result = 16;
                break;
            case DINERSCLUB:
                result = 14;
                break;
            case INSUFFICIENT_DIGITS:
                // this represents the maximum number of digits before we can know the card type
                result = minDigits;
                break;
            case UNKNOWN:
            default:
                result = -1;
                break;
        }
        return result;
    }

    /**
     * @return 4 for Amex, 3 for others, -1 for unknown
     */
    public int cvvLength() {
        int result;
        switch (this) {
            case AMEX:
                result = 4;
                break;
            case JCB:
            case MASTERCARD:
            case MAESTRO:
            case VISA:
            case DISCOVER:
            case DINERSCLUB:
                result = 3;
                break;
            case UNKNOWN:
            default:
                result = -1;
                break;
        }

        return result;
    }


    public Bitmap imageBitmap(Context context) {
        int cardImageResource = -1;
        switch (this) {
            case AMEX: {
                cardImageResource = R.drawable.american_express;
                break;
            }
            case VISA: {
                cardImageResource = R.drawable.visa;
                break;
            }
            case MASTERCARD: {
                cardImageResource = R.drawable.master;
                break;
            }
            case DISCOVER:
            case DINERSCLUB: {
                cardImageResource = R.drawable.discover;
                break;
            }
            case JCB: {
                cardImageResource = R.drawable.jcb;
                break;
            }
            default: {
                // do not use generic image by default, if it's not one of the above, it's not
                // valid, or it's maestro
                break;
            }
        }

        if (cardImageResource != -1) {
            return BitmapFactory.decodeResource(context.getResources(), cardImageResource);
        }

        return null;
    }

    /**
     * Determine if a number matches a prefix interval
     *
     * @param number        credit card number
     * @param intervalStart prefix (e.g. "4") or prefix interval start (e.g. "51")
     * @param intervalEnd   prefix interval end (e.g. "55") or null for non-intervals
     * @return -1 for insufficient digits, 0 for no, 1 for yes.
     */
    private static boolean isNumberInInterval(String number, String intervalStart,
                                              String intervalEnd) {
        int numCompareStart = Math.min(number.length(), intervalStart.length());
        int numCompareEnd = Math.min(number.length(), intervalEnd.length());

        if (Integer.parseInt(number.substring(0, numCompareStart)) < Integer.parseInt(intervalStart
                .substring(0, numCompareStart))) {
            // number is too low
            return false;
        } else if (Integer.parseInt(number.substring(0, numCompareEnd)) > Integer
                .parseInt(intervalEnd.substring(0, numCompareEnd))) {
            // number is too high
            return false;
        }

        return true;
    }

    private static HashMap<Pair<String, String>, CardType> intervalLookup;

    static {
        // initialize
        intervalLookup = new HashMap<>();
        intervalLookup.put(getNewPair("2221", "2720"), CardType.MASTERCARD);    // MasterCard 2-series
        intervalLookup.put(getNewPair("300", "305"), CardType.DINERSCLUB);      // Diners Club
        intervalLookup.put(getNewPair("309", null), CardType.DINERSCLUB);       // Diners Club
        intervalLookup.put(getNewPair("34", null), CardType.AMEX);              // AmEx
        intervalLookup.put(getNewPair("3528", "3589"), CardType.JCB);           // JCB
        intervalLookup.put(getNewPair("36", null), CardType.DINERSCLUB);        // Diners Club
        intervalLookup.put(getNewPair("37", null), CardType.AMEX);              // AmEx
        intervalLookup.put(getNewPair("38", "39"), CardType.DINERSCLUB);        // Diners Club
        intervalLookup.put(getNewPair("4", null), CardType.VISA);               // Visa
        intervalLookup.put(getNewPair("50", null), CardType.MAESTRO);           // Maestro
        intervalLookup.put(getNewPair("51", "55"), CardType.MASTERCARD);        // MasterCard
        intervalLookup.put(getNewPair("56", "59"), CardType.MAESTRO);           // Maestro
        intervalLookup.put(getNewPair("6011", null), CardType.DISCOVER);        // Discover
        intervalLookup.put(getNewPair("61", null), CardType.MAESTRO);           // Maestro
        intervalLookup.put(getNewPair("62", null), CardType.UNION);          // China UnionPay
        intervalLookup.put(getNewPair("63", null), CardType.MAESTRO);           // Maestro
        intervalLookup.put(getNewPair("644", "649"), CardType.DISCOVER);        // Discover
        intervalLookup.put(getNewPair("65", null), CardType.DISCOVER);          // Discover
        intervalLookup.put(getNewPair("66", "69"), CardType.MAESTRO);           // Maestro
        intervalLookup.put(getNewPair("88", null), CardType.UNION);          // China UnionPay

        for (Entry<Pair<String, String>, CardType> entry : getIntervalLookup().entrySet()) {
            minDigits = Math.max(minDigits, entry.getKey().first.length());
            if (entry.getKey().second != null) {
                minDigits = Math.max(minDigits, entry.getKey().second.length());
            }
        }
    }

    private static HashMap<Pair<String, String>, CardType> getIntervalLookup() {
        return intervalLookup;
    }

    private static Pair<String, String> getNewPair(String intervalStart, String intervalEnd) {
        if (intervalEnd == null) {
            // set intervalEnd to intervalStart before creating the Pair object, because apparently
            // Pair.hashCode() can't handle nulls on some devices/versions. WTF.
            intervalEnd = intervalStart;
        }
        return new Pair<String, String>(intervalStart, intervalEnd);
    }

    /**
     * Infer the card type from a string.
     *
     * @param typeStr The String value of this enum
     * @return the matched real type
     */
    public static CardType fromString(String typeStr) {
        if (typeStr == null) {
            return CardType.UNKNOWN;
        }

        for (CardType type : CardType.values()) {
            if (type == CardType.UNKNOWN || type == CardType.INSUFFICIENT_DIGITS) {
                continue;
            }

            if (typeStr.equalsIgnoreCase(type.toString())) {
                return type;
            }
        }
        return CardType.UNKNOWN;
    }

    static CardTypeDetect cardTypeDetect1;

    public static void setCardTypeDetect(CardTypeDetect cardTypeDetect) {
        cardTypeDetect1 = cardTypeDetect;
    }

    public static CardType fromCardNumber(String numStr) {
        if (TextUtils.isEmpty(numStr)) {
            return CardType.UNKNOWN;
        }

        HashSet<CardType> possibleCardTypes = new HashSet<CardType>();
        for (Entry<Pair<String, String>, CardType> entry : getIntervalLookup().entrySet()) {
            boolean isPossibleCard = isNumberInInterval(numStr, entry.getKey().first, entry.getKey().second);
            if (isPossibleCard) {
                possibleCardTypes.add(entry.getValue());
                if (cardTypeDetect1 != null) {
                    cardTypeDetect1.cardType(String.valueOf(entry.getValue()));
                }
//                Const.cardType = String.valueOf(entry.getValue());
            }

        }
        if (possibleCardTypes.size() > 1) {
            return CardType.INSUFFICIENT_DIGITS;
        } else if (possibleCardTypes.size() == 1) {
            return possibleCardTypes.iterator().next();
        } else {
            return CardType.UNKNOWN;
        }
    }

}
