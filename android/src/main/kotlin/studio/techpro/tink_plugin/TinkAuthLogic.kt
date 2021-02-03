package studio.techpro.tink_plugin

import android.net.Uri
import org.json.JSONObject
import java.net.URLDecoder


object TinkAuthResultState {
    const val success = "success"
    const val error = "error"
    const val userCancelled = "user_cancelled"
}

class TinkAuthResult(val state: String,
                     val data: Map<String, String>? = null) {

    fun asJSONString(): String {
        val jsonObject = JSONObject()
        jsonObject.put("state", state)
        if (this.data != null) {
            val dataObject = JSONObject()
            for ((key, value) in this.data) {
                dataObject.put(key, value);
            }
            jsonObject.put("data", dataObject);
        }
        return jsonObject.toString()
    }
}

object TinkAuthDataExtractor {
    fun extractDataFrom(url: Uri, redirectUris: List<String>): TinkAuthResult? {
        if (!redirectUris.any{ url.toString().contains(it) }) {
            return null;
        }
        val parameters = url.query?.split("&") ?: listOf();
        val dict = HashMap<String, String>()
        for (param in parameters){
            val keyValue = param.split("=")
            dict[keyValue[0]] = URLDecoder.decode(keyValue[1], "UTF-8")
        }
        val error = dict["error"]
        return if (error != null){
            if (error == "USER_CANCELLED"){
                TinkAuthResult(state = TinkAuthResultState.userCancelled)
            } else {
                TinkAuthResult(
                    state = TinkAuthResultState.error,
                    data = dict
                )
            }
        } else {
            dict["code"] ?: return null
            return TinkAuthResult(state = TinkAuthResultState.success, data = dict)
        }
    }
}