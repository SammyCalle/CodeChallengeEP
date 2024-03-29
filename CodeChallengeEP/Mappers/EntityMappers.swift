//
//  SiteEntityMapper.swift
//  CodeChallengeEP
//
//  Created by Sammy Alonso Calle Torres on 3/14/24.
//

import Foundation

class EntityMappers {
    static func mapSites(sitesResponse: SitesResponse) -> [SiteEntity] {
        return sitesResponse.sites.map { site in
            return SiteEntity(siteID : site.id,name: site.name, details: site.details, lat: site.location.lat, lon: site.location.lon)
        }
    }
}
